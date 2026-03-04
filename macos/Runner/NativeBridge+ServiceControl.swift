import Foundation
import FlutterMacOS

extension AppDelegate {
  func handleServiceControl(call: FlutterMethodCall, bundleId: String, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    let serviceNameArg = args["serviceName"] as? String
    let configPath = args["configPath"] as? String
    let nodeName = (args["nodeName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    let serviceName = serviceNameArg?.replacingOccurrences(of: ".plist", with: "")

    switch call.method {
    case "startNodeService":
      startNodeServiceWithDirectXray(
        configPath: configPath,
        nodeName: nodeName,
        result: result
      )

    case "stopNodeService":
      stopNodeServiceWithDirectXray(result: result)

    case "checkNodeStatus":
      _ = serviceName
      let running = isDirectXrayRunning()
      if !running {
        result(false)
        return
      }
      guard let currentNode = nodeName, !currentNode.isEmpty else {
        result(true)
        return
      }
      result(readActiveNodeName() == currentNode)

    case "verifySocks5Proxy":
      verifySocks5Proxy(result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startNodeServiceWithDirectXray(
    configPath: String?,
    nodeName: String?,
    result: @escaping FlutterResult
  ) {
    guard let sourceConfig = configPath?.trimmingCharacters(in: .whitespacesAndNewlines),
          !sourceConfig.isEmpty else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing configPath", details: nil))
      return
    }
    guard FileManager.default.fileExists(atPath: sourceConfig) else {
      result(FlutterError(code: "CONFIG_MISSING", message: "source config not found", details: sourceConfig))
      return
    }

    let runtimeLogPath = resolvedRuntimeLogPath()
    guard let xrayExecutable = resolvedXrayExecutablePath() else {
      let details = "configPath=\(sourceConfig), runtimeLog=\(runtimeLogPath), resourcePath=\(Bundle.main.resourcePath ?? "nil")"
      result(FlutterError(code: "PATH_RESOLVE_FAILED", message: "resolve runtime path failed", details: details))
      return
    }
    let requestedNodeName = (nodeName?.isEmpty == false) ? nodeName! : "default-node"
    logToFlutter("info", "startNodeService request node=\(requestedNodeName), sourceConfig=\(sourceConfig)")

    let runningBeforeStart = isDirectXrayRunning()
    if runningBeforeStart {
      let activeNode = readActiveNodeName()
      if activeNode == requestedNodeName {
        result("服务已在运行")
        return
      }
    }
    // Always stop existing instance before a new launch.
    _ = stopDirectXray()
    // Kill any orphaned xray processes left from previous app sessions.
    killOrphanXrayProcesses()
    if isDirectXrayRunning() {
      result(
        FlutterError(
          code: "EXEC_FAILED",
          message: "xray stop existing process failed",
          details: "process still running after terminate"
        )
      )
      return
    }
    if !FileManager.default.isExecutableFile(atPath: xrayExecutable) {
      result(FlutterError(code: "XRAY_MISSING", message: "xray not initialized", details: xrayExecutable))
      return
    }

    logToFlutter("info", "starting xray executable=\(xrayExecutable), configPath=\(sourceConfig), runtimeLog=\(runtimeLogPath)")

    // Prepare directories using FileManager (no shell).
    let fm = FileManager.default
    let logDir = (runtimeLogPath as NSString).deletingLastPathComponent
    try? fm.createDirectory(atPath: logDir, withIntermediateDirectories: true)
    fm.createFile(atPath: runtimeLogPath, contents: nil)

    // Launch xray via Foundation.Process (replaces nohup shell).
    let process = Process()
    process.executableURL = URL(fileURLWithPath: xrayExecutable)
    process.arguments = ["run", "-c", sourceConfig]
    process.currentDirectoryURL = URL(fileURLWithPath: (xrayExecutable as NSString).deletingLastPathComponent)

    do {
      let logFileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: runtimeLogPath))
      logFileHandle.seekToEndOfFile()
      process.standardOutput = logFileHandle
      process.standardError = logFileHandle
    } catch {
      clearActiveNodeName()
      result(FlutterError(code: "LOG_SETUP_FAILED", message: "failed to open log file for writing", details: error.localizedDescription))
      return
    }

    do {
      try process.run()
    } catch {
      clearActiveNodeName()
      result(FlutterError(code: "EXEC_FAILED", message: "start xray failed", details: error.localizedDescription))
      return
    }

    xrayProcess = process

    if waitForDirectXrayReady(runtimeLogPath: runtimeLogPath, timeoutSeconds: 3.0) {
      writeActiveNodeName(requestedNodeName)
      let suffix = requestedNodeName.isEmpty ? "" : " (\(requestedNodeName))"
      result("success: xray started\(suffix)")
      return
    }

    // Startup verification failed — read log tail for diagnostics.
    let logTail = readLogTail(runtimeLogPath: runtimeLogPath, lines: 80)
    clearActiveNodeName()
    result(FlutterError(code: "EXEC_FAILED", message: "xray not running after start", details: logTail))
  }

  private func stopNodeServiceWithDirectXray(result: @escaping FlutterResult) {
    if stopDirectXray() {
      logToFlutter("info", "stopNodeService success")
      clearActiveNodeName()
      result("success")
      return
    }
    logToFlutter("error", "stopNodeService failed: process still running")
    result("停止失败: 进程仍在运行")
  }

  private func isDirectXrayRunning() -> Bool {
    // 1. Check the in-memory process reference.
    if let process = xrayProcess, process.isRunning {
      return true
    }
    // 2. Fallback: check if any xray process is running on the system.
    //    This catches orphaned processes from previous app launches.
    return isAnyXrayRunningOnSystem()
  }

  /// Check the system process table for any running xray instances.
  private func isAnyXrayRunningOnSystem() -> Bool {
    let task = Process()
    task.launchPath = "/usr/bin/pgrep"
    task.arguments = ["-f", "xray run -c"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = Pipe()
    do {
      try task.run()
      task.waitUntilExit()
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      return task.terminationStatus == 0 && !output.isEmpty
    } catch {
      return false
    }
  }

  /// Kill all orphaned xray processes on the system, preserving `xrayProcess` if it is still valid.
  func killOrphanXrayProcesses() {
    let task = Process()
    task.launchPath = "/usr/bin/pgrep"
    task.arguments = ["-f", "xray run -c"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = Pipe()
    do {
      try task.run()
      task.waitUntilExit()
    } catch {
      return
    }
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let pids = (String(data: data, encoding: .utf8) ?? "")
      .components(separatedBy: .newlines)
      .compactMap { Int32($0.trimmingCharacters(in: .whitespaces)) }

    let managedPid = xrayProcess?.processIdentifier
    var killed = 0
    for pid in pids {
      if pid == managedPid { continue }  // Don't kill our own managed process.
      kill(pid, SIGTERM)
      killed += 1
    }
    if killed > 0 {
      logToFlutter("warn", "killed \(killed) orphan xray process(es): \(pids.filter { $0 != managedPid })")
      // Give them a moment to exit, then force kill any survivors.
      Thread.sleep(forTimeInterval: 0.5)
      for pid in pids {
        if pid == managedPid { continue }
        kill(pid, SIGKILL)
      }
    }
  }

  func stopDirectXray() -> Bool {
    guard let process = xrayProcess else {
      // No managed reference, but orphans may exist – handled separately.
      return true
    }
    if process.isRunning {
      process.terminate()
      // Give process time to exit gracefully.
      let deadline = Date().addingTimeInterval(2.0)
      while process.isRunning && Date() < deadline {
        Thread.sleep(forTimeInterval: 0.1)
      }
      // Force kill if still running.
      if process.isRunning {
        kill(process.processIdentifier, SIGKILL)
        Thread.sleep(forTimeInterval: 0.3)
      }
    }
    let stopped = !process.isRunning
    xrayProcess = nil
    return stopped
  }

  private func waitForDirectXrayReady(runtimeLogPath: String, timeoutSeconds: TimeInterval) -> Bool {
    let started = Date()
    while Date().timeIntervalSince(started) < timeoutSeconds {
      guard isDirectXrayRunning() else {
        // Process exited prematurely.
        return false
      }
      if hasXrayStartedMarker(runtimeLogPath: runtimeLogPath) {
        return true
      }
      Thread.sleep(forTimeInterval: 0.25)
    }
    return isDirectXrayRunning() && hasXrayStartedMarker(runtimeLogPath: runtimeLogPath)
  }

  private func hasXrayStartedMarker(runtimeLogPath: String) -> Bool {
    guard let content = try? String(contentsOfFile: runtimeLogPath, encoding: .utf8) else {
      return false
    }
    let lines = content.components(separatedBy: .newlines)
    let tail = lines.suffix(120).joined(separator: "\n")
    let pattern = #"core: Xray .* started|Xray [0-9]+\.[0-9]+\.[0-9]+ started"#
    return tail.range(of: pattern, options: .regularExpression) != nil
  }

  private func readLogTail(runtimeLogPath: String, lines: Int) -> String {
    guard let content = try? String(contentsOfFile: runtimeLogPath, encoding: .utf8) else {
      return ""
    }
    let allLines = content.components(separatedBy: .newlines)
    return allLines.suffix(lines).joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func verifySocks5Proxy(result: @escaping FlutterResult) {
    guard isDirectXrayRunning() else {
      result("验证失败: xray 未运行")
      return
    }

    let endpoints = [
      "https://api.ipify.org",
      "https://ifconfig.me/ip",
      "http://api.ipify.org",
      "http://ifconfig.me/ip",
    ]
    var lastError = ""

    for endpoint in endpoints {
      let (ok, output) = runCommandAndCapture(
        executable: "/usr/bin/curl",
        arguments: [
          "--silent",
          "--show-error",
          "--max-time",
          "12",
          "--socks5-hostname",
          "127.0.0.1:1080",
          endpoint,
        ]
      )
      let normalized = output.trimmingCharacters(in: .whitespacesAndNewlines)
      if ok && !normalized.isEmpty {
        result("success: socks5 可用，出口 IP=\(normalized)")
        return
      }
      if !normalized.isEmpty {
        lastError = normalized
      }
    }

    result("验证失败: \(lastError.isEmpty ? "socks5 请求无响应" : lastError)")
  }

  private func runCommandAndCapture(executable: String, arguments: [String]) -> (Bool, String) {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: executable)
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    do {
      try task.run()
      task.waitUntilExit()
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      let output = String(data: data, encoding: .utf8) ?? ""
      return (task.terminationStatus == 0, output)
    } catch {
      return (false, error.localizedDescription)
    }
  }

  private func resolvedAppSupportRoot() -> URL? {
    let fileManager = FileManager.default
    guard let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
      return nil
    }
    let bundleId = Bundle.main.bundleIdentifier ?? "com.xstream"
    let root = appSupport.appendingPathComponent(bundleId, isDirectory: true)
    try? fileManager.createDirectory(at: root, withIntermediateDirectories: true)
    return root
  }

  private func resolvedRuntimeLogPath() -> String {
    let logsDir = resolvedRuntimeBaseDir().appendingPathComponent("logs", isDirectory: true)
    try? FileManager.default.createDirectory(at: logsDir, withIntermediateDirectories: true)
    return logsDir.appendingPathComponent("xray-runtime.log").path
  }

  private func resolvedXrayExecutablePath() -> String? {
    guard let bundledPath = resolvedBundledXrayPath() else {
      return nil
    }
    let fileManager = FileManager.default
    guard fileManager.isExecutableFile(atPath: bundledPath) else {
      logToFlutter("error", "bundled xray is not executable: \(bundledPath)")
      return nil
    }
    // App Store compliance: run only the bundled, signed executable.
    return bundledPath
  }

  private func shellEscaped(_ value: String) -> String {
    let escaped = value.replacingOccurrences(of: "'", with: "'\"'\"'")
    return "'\(escaped)'"
  }

  private func normalizedArch() -> String {
    let process = Process()
    process.launchPath = "/usr/bin/uname"
    process.arguments = ["-m"]
    let pipe = Pipe()
    process.standardOutput = pipe
    do {
      try process.run()
      process.waitUntilExit()
      let data = pipe.fileHandleForReading.readDataToEndOfFile()
      return String(data: data, encoding: .utf8)?
        .trimmingCharacters(in: .whitespacesAndNewlines) ?? "arm64"
    } catch {
      return "arm64"
    }
  }

  private func resolvedStateDirectory() -> URL? {
    guard let root = resolvedAppSupportRoot() else { return nil }
    let stateDir = root.appendingPathComponent("state", isDirectory: true)
    try? FileManager.default.createDirectory(at: stateDir, withIntermediateDirectories: true)
    return stateDir
  }

  private func resolvedActiveNodeNamePath() -> URL? {
    guard let stateDir = resolvedStateDirectory() else { return nil }
    return stateDir.appendingPathComponent("active_node_name.txt")
  }

  private func writeActiveNodeName(_ nodeName: String) {
    guard let fileURL = resolvedActiveNodeNamePath() else { return }
    try? nodeName.write(to: fileURL, atomically: true, encoding: .utf8)
  }

  private func readActiveNodeName() -> String? {
    guard let fileURL = resolvedActiveNodeNamePath(),
          let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
      return nil
    }
    let name = content.trimmingCharacters(in: .whitespacesAndNewlines)
    return name.isEmpty ? nil : name
  }

  private func clearActiveNodeName() {
    guard let fileURL = resolvedActiveNodeNamePath() else { return }
    try? FileManager.default.removeItem(at: fileURL)
  }

  private func resolvedBundledXrayPath() -> String? {
    guard let resourcePath = Bundle.main.resourcePath else { return nil }
    let arch = normalizedArch()
    let candidates: [String] = (arch == "x86_64")
      ? [
        "\(resourcePath)/xray-x86_64",
        "\(resourcePath)/xray",
        "\(resourcePath)/xray/xray-x86_64",
        "\(resourcePath)/xray/xray",
        "\(resourcePath)/xray.x86_64",
        "\(resourcePath)/xray-arm64",
      ]
      : [
        "\(resourcePath)/xray",
        "\(resourcePath)/xray-arm64",
        "\(resourcePath)/xray/xray",
        "\(resourcePath)/xray/xray-arm64",
        "\(resourcePath)/xray-x86_64",
        "\(resourcePath)/xray.x86_64",
      ]
    return candidates.first(where: { FileManager.default.fileExists(atPath: $0) })
  }

  private func resolvedRuntimeBaseDir() -> URL {
    let fileManager = FileManager.default
    if let root = resolvedAppSupportRoot() {
      return root
    }
    let fallback = fileManager.temporaryDirectory
      .appendingPathComponent("xstream-runtime", isDirectory: true)
    try? fileManager.createDirectory(at: fallback, withIntermediateDirectories: true)
    return fallback
  }
}

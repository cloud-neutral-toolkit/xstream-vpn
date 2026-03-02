import Foundation
import FlutterMacOS

extension AppDelegate {
  func handleSystemProxy(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let enable = args["enable"] as? Bool,
          let password = args["password"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing enable/password", details: nil))
      return
    }

    switch call.method {
    case "setSystemProxy":
      runSetSystemProxy(enable: enable, password: password, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func runSetSystemProxy(enable: Bool, password: String, result: @escaping FlutterResult) {
    let script: String
    if enable {
      script = """
services=$(networksetup -listallnetworkservices | tail +2)
for s in $services; do
  networksetup -setsocksfirewallproxy "$s" 127.0.0.1 1080
  networksetup -setsocksfirewallproxystate "$s" on
done
"""
    } else {
      script = """
services=$(networksetup -listallnetworkservices | tail +2)
for s in $services; do
  networksetup -setsocksfirewallproxystate "$s" off
done
"""
    }

    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/sudo")
    task.arguments = ["-S", "/bin/bash", "-c", script]

    let outputPipe = Pipe()
    let inputPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardError = outputPipe
    task.standardInput = inputPipe

    do {
      try task.run()
      let stdin = inputPipe.fileHandleForWriting
      if let passwordData = (password + "\n").data(using: .utf8) {
        stdin.write(passwordData)
      }
      stdin.closeFile()

      task.waitUntilExit()
      let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
      let output = String(data: data, encoding: .utf8) ?? ""
      if task.terminationStatus == 0 {
        result("success")
        logToFlutter("info", "setSystemProxy success")
      } else {
        result(FlutterError(code: "EXEC_FAILED", message: "Command failed", details: output))
        logToFlutter("error", "setSystemProxy failed: \(output)")
      }
    } catch {
      result(FlutterError(code: "EXEC_ERROR", message: "Process failed to run", details: error.localizedDescription))
      logToFlutter("error", "setSystemProxy process error: \(error.localizedDescription)")
    }
  }
}

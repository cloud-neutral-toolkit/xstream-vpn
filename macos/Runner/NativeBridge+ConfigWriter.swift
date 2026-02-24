// NativeBridge+ConfigWriter.swift
import Foundation
import FlutterMacOS

extension AppDelegate {
  func writeConfigFiles(call: FlutterMethodCall, result: @escaping FlutterResult) {
    // 获取传递的参数
    guard let args = call.arguments as? [String: Any],
          let xrayConfigPath = args["xrayConfigPath"] as? String,
          let xrayConfigContent = args["xrayConfigContent"] as? String, // 修改这里
          let servicePath = args["servicePath"] as? String,
          let serviceContent = args["serviceContent"] as? String,
          let vpnNodesConfigPath = args["vpnNodesConfigPath"] as? String,
          let vpnNodesConfigContent = args["vpnNodesConfigContent"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "缺少必要的参数", details: nil))
      return
    }

    do {
      // 写入 Xray 配置文件
      try writeXrayConfig(path: xrayConfigPath, content: xrayConfigContent)
      // 写入 Plist 配置文件
      try writePlistFile(path: servicePath, content: serviceContent)
      // 更新 vpn_nodes.json 文件
      try updateVpnNodesConfig(path: vpnNodesConfigPath, content: vpnNodesConfigContent)
      // 返回成功消息
      result("Configuration files written successfully")
    } catch {
      // 捕获并返回错误
      result(FlutterError(code: "WRITE_ERROR", message: "写入失败", details: error.localizedDescription))
      logToFlutter("error", "写入失败: \(error.localizedDescription)")
    }
  }

  private func writeXrayConfig(path: String, content: String) throws {
    self.logToFlutter("info", "创建 Xray 配置文件: \(path)")
    try writeStringToFile(path: path, content: content)
  }

  private func writePlistFile(path: String, content: String) throws {
    self.logToFlutter("info", "写入 LaunchAgent plist: \(path)")
    try writeStringToFile(path: path, content: content)
  }

  private func updateVpnNodesConfig(path: String, content: String) throws {
    self.logToFlutter("info", "更新 vpn_nodes.json: \(path)")
    let fileManager = FileManager.default
    
    // 确保目录存在
    let directoryPath = (path as NSString).deletingLastPathComponent
    try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)

    // 读取现有的 vpn_nodes.json 文件内容
    var vpnNodes: [[String: Any]] = []

    if fileManager.fileExists(atPath: path) {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        if data.count > 0 {
          vpnNodes = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
          self.logToFlutter("info", "读取现有配置成功: \(path), 已有节点数: \(vpnNodes.count)")
        }
      } catch {
        self.logToFlutter("warning", "读取现有配置失败: \(error.localizedDescription)")
      }
    }

    // 解析新的节点数据
    guard let contentData = content.data(using: .utf8),
          let newNodes = try? JSONSerialization.jsonObject(with: contentData, options: []) as? [[String: Any]] else {
      throw NSError(domain: "vpn_nodes_json", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON content for new node"])
    }

    // 合并新节点到现有节点，避免重复
    for newNode in newNodes {
      guard let newNodeName = newNode["name"] as? String else { continue }
      
      if let existingIndex = vpnNodes.firstIndex(where: { node in
        (node["name"] as? String) == newNodeName
      }) {
        vpnNodes[existingIndex] = newNode
      } else {
        vpnNodes.append(newNode)
      }
    }

    // 生成最终的 JSON 数据
    let updatedJson = try JSONSerialization.data(withJSONObject: vpnNodes, options: .prettyPrinted)
    let finalContent = String(data: updatedJson, encoding: .utf8) ?? "[]"

    // 将更新后的内容写入文件
    try writeStringToFile(path: path, content: finalContent)
    self.logToFlutter("info", "vpn_nodes.json 写入成功: \(path), 总节点数: \(vpnNodes.count)")
  }

  private func writeStringToFile(path: String, content: String) throws {
    let fileUrl = URL(fileURLWithPath: path)
    let directoryUrl = fileUrl.deletingLastPathComponent()
    try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
    try content.write(to: fileUrl, atomically: true, encoding: .utf8)
  }
}

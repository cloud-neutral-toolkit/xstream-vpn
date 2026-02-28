import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var isRunningUnitTests: Bool {
    ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if isRunningUnitTests {
      return true
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let messenger = engineBridge.applicationRegistrar.messenger()
    let api = DarwinHostApiImpl(binaryMessenger: messenger)
    DarwinHostApiSetup.setUp(binaryMessenger: messenger, api: api)

    let channel = FlutterMethodChannel(name: "com.xstream/native", binaryMessenger: messenger)
    let bundleId = Bundle.main.bundleIdentifier ?? "com.xstream"
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "writeConfigFiles":
        self.writeConfigFiles(call: call, result: result)
      case "startNodeService", "stopNodeService", "checkNodeStatus":
        self.handleServiceControl(call: call, result: result)
      case "performAction":
        self.handlePerformAction(call: call, bundleId: bundleId, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

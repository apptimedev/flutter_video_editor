import Flutter
import UIKit

public class SwiftFlutterVideoEditorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_video_editor", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterVideoEditorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "writeVideoFile":
            let video = VideoGeneratorService()
            guard let args = call.arguments as? [String: Any] else {
              result(FlutterError(code: "arguments_not_found",
                                message: "the arguments is not found.",
                                details: nil))
              return
            }
            guard let srcName = args["srcFilePath"] as? String else {
                    result(FlutterError(code: "src_file_path_not_found",
                                      message: "the src file path sr is not found.",
                                      details: nil))
                    return
            }
            guard let destName = args["destFilePath"] as? String else {
                    result(FlutterError(code: "dest_file_path_not_found",
                                      message: "the dest file path is not found.",
                                      details: nil))
                    return
            }
            guard let processing = args["processing"] as?  [String: [String: Any]] else {
                    result(FlutterError(code: "processing_data_not_found",
                                      message: "the processing is not found.",
                                      details: nil))
                    return
            }
            video.writeVideoFile(srcPath: srcName, destPath: destName, processing: processing,result: result)
        default:
            result(FlutterError(code: "not_implemented",
                              message: "Not implemented.",
                              details: nil))
        }
  }
}

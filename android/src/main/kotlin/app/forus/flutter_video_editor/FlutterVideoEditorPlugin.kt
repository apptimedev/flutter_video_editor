package app.forus.flutter_video_editor

import android.Manifest
import android.app.Application
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Environment
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.daasuu.mp4compose.composer.Mp4Composer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.PluginRegistry
import app.forus.flutter_video_editor.VideoGeneratorService
import java.io.File


/** FlutterVideoEditorPlugin */
class FlutterVideoEditorPlugin : FlutterPlugin, MethodCallHandler, PluginRegistry.RequestPermissionsResultListener,
    ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    var activity: Activity? = null
    private var channel: MethodChannel? = null
    private val myPermissionCode = 34264

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.binaryMessenger)
    }

    fun onAttachedToEngine(messenger: BinaryMessenger) {
        channel = MethodChannel(messenger, "flutter_video_editor")
        channel?.setMethodCallHandler(this)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = FlutterVideoEditorPlugin()
            instance.onAttachedToEngine(registrar.messenger())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "writeVideoFile") {
            var getActivity = activity ?: return
            checkPermission(getActivity)

            val srcFilePath: String = call.argument("srcFilePath") ?: run {
                result.error("src_file_path_not_found", "the src file path is not found.", null)
                return
            }
            val destFilePath: String = call.argument("destFilePath") ?: run {
                result.error("dest_file_path_not_found", "the dest file path is not found.", null)
                return
            }
            val processing: HashMap<String, HashMap<String, Any>> = call.argument("processing")
                ?: run {
                    result.error("processing_data_not_found", "the processing is not found.", null)
                    return
                }
            val generator = VideoGeneratorService(Mp4Composer(srcFilePath, destFilePath))
            generator.writeVideoFile(processing, result, getActivity)
        } else {
            result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
    }

    override fun onDetachedFromActivity() {
        channel!!.setMethodCallHandler(null)
        channel = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        when (requestCode) {
            myPermissionCode -> {
                // Only return true if handling the requestCode
                return true
            }
        }
        return false
    }

    // Invoked either from the permission result callback or permission check
    private fun completeInitialization() {

    }

    private fun checkPermission(activity: Activity) {
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE),
            myPermissionCode
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }
}

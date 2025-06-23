package com.example.treadscan

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.treadscan.NativeImageProcessor

class MainActivity : FlutterActivity() {
    private val CHANNEL = "image_processor"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "processImage") {
                    val args = call.arguments as Map<String, Any>
                    val imageBytes = args["image"] as ByteArray
                    val noiseMethod = args["noiseMethod"] as Int
                    val kernelSize = args["kernelSize"] as Int
                    val sigma = args["sigma"] as Double
                    val brightness = args["brightness"] as Double
                    val contrast = args["contrast"] as Double
                    val skewX = args["skewX"] as Double
                    val skewY = args["skewY"] as Double

                    val processed = NativeImageProcessor.processImage(
                        imageBytes,
                        noiseMethod,
                        kernelSize,
                        sigma,
                        brightness,
                        contrast,
                        skewX,
                        skewY
                    )

                    result.success(processed)
                } else {
                    result.notImplemented()
                }
            }
    }
}
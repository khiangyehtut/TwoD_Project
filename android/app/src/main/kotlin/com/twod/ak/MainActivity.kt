package com.twod.ak

import android.content.res.Configuration
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "keyboard.check/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "isPhysicalKeyboardConnected") {
                    val config = resources.configuration
                    val isConnected = config.keyboard != Configuration.KEYBOARD_NOKEYS &&
                                      config.hardKeyboardHidden == Configuration.HARDKEYBOARDHIDDEN_NO

                    println("🎹 keyboard=${config.keyboard}, hidden=${config.hardKeyboardHidden}, result=$isConnected")
                    result.success(isConnected)
                } else {
                    result.notImplemented()
                }
            }
    }
}
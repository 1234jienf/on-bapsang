package com.bapful.onbapsang

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.bapful.onbapsang/config"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getGoogleMapsApiKey" -> {
                    try {
                        // BuildConfig에서 API 키 가져오기
                        result.success(BuildConfig.GOOGLE_MAPS_API_KEY)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to get API key", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
package com.example.crepe_plugin

import android.content.Context
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class CrepePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "crepe_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "echo" -> {
        val value = call.argument<String>("value") ?: ""
        result.success("Echo: $value")
      }
      "startAccessibilityService" -> {
        val intent = Intent(context, MyAccessibilityService::class.java)
        context.startService(intent)
        result.success(null)
      }
      "stopAccessibilityService" -> {
        val intent = Intent(context, MyAccessibilityService::class.java)
        context.stopService(intent)
        result.success(null)
      }
      "getAccessibilityData" -> {
        val data = MyAccessibilityService.getLatestAccessibilityData()
        result.success(data)
      }
      "openAccessibilitySettings" -> {
        try {
          val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
          intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
          context.startActivity(intent)
          result.success(null)
        } catch (e: Exception) {
          result.error("SETTINGS_ERROR", "Could not open accessibility settings: ${e.message}", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
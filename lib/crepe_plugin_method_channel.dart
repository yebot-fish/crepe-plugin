import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'crepe_plugin_platform_interface.dart';

/// An implementation of [CrepePluginPlatform] that uses method channels.
class MethodChannelCrepePlugin extends CrepePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('crepe_plugin');

  @override
  Future<String?> echo(String value) async {
    final result = await methodChannel.invokeMethod<String>('echo', {'value': value});
    return result;
  }

  @override
  Future<void> startAccessibilityService() async {
    await methodChannel.invokeMethod('startAccessibilityService');
  }

  @override
  Future<void> stopAccessibilityService() async {
    await methodChannel.invokeMethod('stopAccessibilityService');
  }

  @override
  Future<String?> getAccessibilityData() async {
    final result = await methodChannel.invokeMethod<String>('getAccessibilityData');
    return result;
  }

  @override
  Future<void> openAccessibilitySettings() async {
    await methodChannel.invokeMethod('openAccessibilitySettings');
  }
}

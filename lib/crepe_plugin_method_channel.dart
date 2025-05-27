import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'crepe_plugin_platform_interface.dart';

/// An implementation of [CrepePluginPlatform] that uses method channels.
class MethodChannelCrepePlugin extends CrepePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('crepe_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

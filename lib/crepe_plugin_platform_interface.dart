import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'crepe_plugin_method_channel.dart';

abstract class CrepePluginPlatform extends PlatformInterface {
  /// Constructs a CrepePluginPlatform.
  CrepePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CrepePluginPlatform _instance = MethodChannelCrepePlugin();

  /// The default instance of [CrepePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCrepePlugin].
  static CrepePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CrepePluginPlatform] when
  /// they register themselves.
  static set instance(CrepePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> echo(String value) {
    throw UnimplementedError('echo() has not been implemented.');
  }

  Future<void> startAccessibilityService() {
    throw UnimplementedError('startAccessibilityService() has not been implemented.');
  }

  Future<void> stopAccessibilityService() {
    throw UnimplementedError('stopAccessibilityService() has not been implemented.');
  }

  Future<String?> getAccessibilityData() {
    throw UnimplementedError('getAccessibilityData() has not been implemented.');
  }

  Future<void> openAccessibilitySettings() {
    throw UnimplementedError('openAccessibilitySettings() has not been implemented.');
  }
}

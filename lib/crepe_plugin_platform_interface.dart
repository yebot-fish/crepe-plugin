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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

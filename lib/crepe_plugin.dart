
import 'crepe_plugin_platform_interface.dart';

class CrepePlugin {
  Future<String?> getPlatformVersion() {
    return CrepePluginPlatform.instance.getPlatformVersion();
  }
}

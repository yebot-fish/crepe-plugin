import 'crepe_plugin_platform_interface.dart';

class CrepePlugin {
  Future<String?> echo(String value) {
    return CrepePluginPlatform.instance.echo(value);
  }

  Future<void> startAccessibilityService() {
    return CrepePluginPlatform.instance.startAccessibilityService();
  }

  Future<void> stopAccessibilityService() {
    return CrepePluginPlatform.instance.stopAccessibilityService();
  }

  Future<String?> getAccessibilityData() {
    return CrepePluginPlatform.instance.getAccessibilityData();
  }

  Future<void> openAccessibilitySettings() {
    return CrepePluginPlatform.instance.openAccessibilitySettings();
  }
}

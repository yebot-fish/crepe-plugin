import 'package:flutter_test/flutter_test.dart';
import 'package:crepe_plugin/crepe_plugin.dart';
import 'package:crepe_plugin/crepe_plugin_platform_interface.dart';
import 'package:crepe_plugin/crepe_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCrepePluginPlatform
    with MockPlatformInterfaceMixin
    implements CrepePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CrepePluginPlatform initialPlatform = CrepePluginPlatform.instance;

  test('$MethodChannelCrepePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCrepePlugin>());
  });

  test('getPlatformVersion', () async {
    CrepePlugin crepePlugin = CrepePlugin();
    MockCrepePluginPlatform fakePlatform = MockCrepePluginPlatform();
    CrepePluginPlatform.instance = fakePlatform;

    expect(await crepePlugin.getPlatformVersion(), '42');
  });
}

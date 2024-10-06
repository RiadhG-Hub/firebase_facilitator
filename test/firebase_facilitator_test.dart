import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_facilitator/firebase_facilitator.dart';
import 'package:firebase_facilitator/firebase_facilitator_platform_interface.dart';
import 'package:firebase_facilitator/firebase_facilitator_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFirebaseFacilitatorPlatform
    with MockPlatformInterfaceMixin
    implements FirebaseFacilitatorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FirebaseFacilitatorPlatform initialPlatform = FirebaseFacilitatorPlatform.instance;

  test('$MethodChannelFirebaseFacilitator is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFirebaseFacilitator>());
  });

  test('getPlatformVersion', () async {
    FirebaseFacilitator firebaseFacilitatorPlugin = FirebaseFacilitator();
    MockFirebaseFacilitatorPlatform fakePlatform = MockFirebaseFacilitatorPlatform();
    FirebaseFacilitatorPlatform.instance = fakePlatform;

    expect(await firebaseFacilitatorPlugin.getPlatformVersion(), '42');
  });
}

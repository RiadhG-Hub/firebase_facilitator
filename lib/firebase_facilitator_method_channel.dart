import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'firebase_facilitator_platform_interface.dart';

/// An implementation of [FirebaseFacilitatorPlatform] that uses method channels.
class MethodChannelFirebaseFacilitator extends FirebaseFacilitatorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('firebase_facilitator');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

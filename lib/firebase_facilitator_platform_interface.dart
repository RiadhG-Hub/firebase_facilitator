import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'firebase_facilitator_method_channel.dart';

abstract class FirebaseFacilitatorPlatform extends PlatformInterface {
  /// Constructs a FirebaseFacilitatorPlatform.
  FirebaseFacilitatorPlatform() : super(token: _token);

  static final Object _token = Object();

  static FirebaseFacilitatorPlatform _instance = MethodChannelFirebaseFacilitator();

  /// The default instance of [FirebaseFacilitatorPlatform] to use.
  ///
  /// Defaults to [MethodChannelFirebaseFacilitator].
  static FirebaseFacilitatorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FirebaseFacilitatorPlatform] when
  /// they register themselves.
  static set instance(FirebaseFacilitatorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

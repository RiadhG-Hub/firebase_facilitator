
import 'firebase_facilitator_platform_interface.dart';

class FirebaseFacilitator {
  Future<String?> getPlatformVersion() {
    return FirebaseFacilitatorPlatform.instance.getPlatformVersion();
  }
}

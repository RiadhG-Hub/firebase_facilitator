#include "include/firebase_facilitator/firebase_facilitator_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "firebase_facilitator_plugin.h"

void FirebaseFacilitatorPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  firebase_facilitator::FirebaseFacilitatorPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

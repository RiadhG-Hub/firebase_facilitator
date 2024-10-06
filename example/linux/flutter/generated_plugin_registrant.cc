//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_facilitator/firebase_facilitator_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) firebase_facilitator_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FirebaseFacilitatorPlugin");
  firebase_facilitator_plugin_register_with_registrar(firebase_facilitator_registrar);
}

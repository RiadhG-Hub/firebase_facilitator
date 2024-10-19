import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_facilitator_example/pages/storage_example_page.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MaterialApp(home: StorageExamplePage()));
}

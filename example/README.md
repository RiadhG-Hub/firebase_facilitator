# firebase_facilitator_example

[![pub package](https://img.shields.io/pub/v/firebase_facilitator.svg)](https://pub.dev/packages/firebase_facilitator)
[![pub points](https://img.shields.io/pub/points/firebase_facilitator?color=2E8B57&label=pub%20points)](https://pub.dev/packages/firebase_facilitator/score)
[![firebase_facilitator](https://github.com/yourgithub/firebase_facilitator/actions/workflows/firebase_facilitator.yaml/badge.svg)](https://github.com/yourgithub/firebase_facilitator/actions/workflows/firebase_facilitator.yaml)

[<img src="https://flutter.dev/assets/flutter-lockup-bg.jpg" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

A package that provides mixins for facilitating CRUD operations with Firestore in Flutter applications.

## Platform Support

| Android | iOS | Web | MacOS | Windows | Linux |
| :-----: | :-: | :-: | :---: | :-----: | :---: |
|   ✅    | ✅  | ✅  |  ✅   |   ✅    |   ✅   |

## Requirements

- Flutter >=3.3.0
- cloud_firestore: ^5.4.4
- fake_cloud_firestore: ^3.0.3
- firebase_auth: ^5.3.1
- firebase_core: ^3.6.0
- logger: ^2.4.0

# Usage

Import the `firebase_facilitator` package, implement the mixins for CRUD operations and logger services, and use the repository to perform Firestore operations.

Example:

```dart
import 'package:firebase_facilitator/mixin/crud_repos.dart';
import 'package:firebase_facilitator/mixin/firestore_read_service.dart';
import 'package:firebase_facilitator/mixin/firestore_write_service.dart';
import 'package:firebase_facilitator/mixin/logger_service.dart';

class ReadWriteReposExample
    with FirestoreReadRepository, FirestoreWriteRepository {
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  @override
  FirestoreWriteService get firestoreWriteService =>
      FirestoreWriteServiceImpl();

  @override
  LoggerService? get loggerService => LoggerServiceImpl(true);

  @override
  String get collection => "collection_example";
}
```




Example Widget:

Example:

```dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ReadWriteExamplePage extends StatefulWidget {
  const ReadWriteExamplePage({super.key});

  @override
  State<ReadWriteExamplePage> createState() => _ReadWriteExamplePageState();
}

class _ReadWriteExamplePageState extends State<ReadWriteExamplePage> {
  ReadWriteReposExample readWriteReposExample = ReadWriteReposExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firestore Operations Example")),
      body: Column(
        children: [
          MaterialButton(
            color: Colors.blue,
            onPressed: _onAddDataPressed,
            child: const Text('Add Data'),
          ),
          MaterialButton(
            color: Colors.green,
            onPressed: _onFetchAllDocumentsPressed,
            child: const Text('Fetch All Documents'),
          ),
        ],
      ),
    );
  }

  void _onAddDataPressed() {
    readWriteReposExample.saveDocument(data: {"id": const Uuid().v4(), "name": "john"});
  }

  void _onFetchAllDocumentsPressed() {
    readWriteReposExample.fetchAllDocuments();
  }
}
```

The repository handles Firestore operations, including adding, fetching, and deleting documents.


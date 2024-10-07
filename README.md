

# firebase\_facilitator

[![pub package version](https://img.shields.io/pub/v/firebase_facilitator.svg)](https://pub.dev/packages/firebase_facilitator)[![pub points](https://img.shields.io/pub/points/firebase_facilitator?color=2E8B57&label=pub%20points)](https://pub.dev/packages/firebase_facilitator/score)

**firebase\_facilitator** is a versatile package that streamlines CRUD operations with Firestore in Flutter applications. It provides mixins for handling common tasks like Create, Read, Update, and Delete, along with optional logging functionality.

## Platform Support

| Android | iOS | Web | macOS | Windows | Linux |
| --- | --- | --- | --- | --- | --- |
| ✅   | ✅   | ✅   | ✅   | ✅   | ✅   |

## Requirements

*   Flutter >= 3.3.0
*   `cloud_firestore: ^5.4.4`
*   `fake_cloud_firestore: ^3.0.3`
*   `firebase_auth: ^5.3.1` (optional, for authentication)
*   `firebase_core: ^3.6.0`
*   `logger: ^2.4.0` (optional, for logging)

## Usage

To use the **firebase\_facilitator** package, simply import the necessary mixins and integrate them into your data repository class for seamless Firestore operations.

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
  LoggerService? get loggerService => LoggerServiceImpl(true); // Optional

  @override
  String get collection => "collection_example";
}
    
```

## Example Widget

This example demonstrates how to interact with Firestore using the **ReadWriteReposExample** repository for adding and fetching documents.

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
  final ReadWriteReposExample readWriteReposExample = ReadWriteReposExample();

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

The `ReadWriteReposExample` class handles Firestore operations like adding, fetching, and deleting documents, allowing developers to focus on business logic while abstracting the complexity of Firestore.
import 'dart:developer';

import 'package:firebase_facilitator_example/helper/operation_runner.dart';
import 'package:firebase_facilitator_example/repository/write_repos_example.dart';
import 'package:flutter/material.dart';

/// A page widget that provides examples of writing and deleting data
/// from a Firestore collection. This class demonstrates how to interact
/// with Firestore through a repository pattern and provides basic UI feedback.
class WriteExamplePage extends StatefulWidget {
  const WriteExamplePage({super.key});

  @override
  State<WriteExamplePage> createState() => _WriteExamplePageState();
}

/// State class for [WriteExamplePage] that manages interactions with
/// the repository for saving and deleting documents.
class _WriteExamplePageState extends State<WriteExamplePage> implements OperationCheckerService {
  late final OperationRunner runner;

  /// Callback to handle a failed operation.
  ///
  /// [exception] contains the error message returned by the failed operation.
  @override
  void onFailed(dynamic exception) {
    log("Operation failed: $exception");
  }

  /// Callback to handle a successful operation.
  ///
  /// [message] contains the success message returned by the successful operation.
  @override
  void onSuccess(dynamic message) {
    log("Operation successful: $message");
  }

  @override
  void initState() {
    runner = OperationRunner(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Write Example"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text("Click the button below to add data to the collection:"),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _onAddDataPressed,
              child: const Text('Add Data'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text("Click the button below to delete data from the collection:"),
            ),
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              onPressed: _onDeleteDataPressed,
              child: const Text('Delete Data'),
            ),
          ],
        ),
      ),
    );
  }

  /// Triggered when the "Add Data" button is pressed.
  ///
  /// This method initiates the process of adding a new document to the Firestore
  /// collection using the [WriteReposExample] class and handles the operation result.
  void _onAddDataPressed() {
    WriteReposExample writeReposExample = WriteReposExample();

    // Attempt to add a new document to the Firestore collection
    runner.runOperation(writeReposExample.saveDocument(data: {"id": "id_example", "name": "john"}));
  }

  /// Triggered when the "Delete Data" button is pressed.
  ///
  /// This method initiates the process of deleting a document from the Firestore
  /// collection using the [WriteReposExample] class and handles the operation result.
  void _onDeleteDataPressed() {
    WriteReposExample writeReposExample = WriteReposExample();

    // Attempt to delete a document from the Firestore collection
    runner.runOperation(writeReposExample.deleteDocument(documentId: 'id_example'));
  }
}

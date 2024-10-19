import 'dart:developer';

import 'package:firebase_facilitator/mixin/helper/operation_runner.dart';
import 'package:firebase_facilitator_example/repository/read_repository_example.dart';
import 'package:firebase_facilitator_example/repository/write_repos_example.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A page widget that demonstrates examples of reading and writing data
/// to and from a Firestore collection using a repository pattern.
/// This class provides user-friendly UI feedback and executes operations
/// through an [OperationRunner].
class ReadExamplePage extends StatefulWidget {
  const ReadExamplePage({super.key});

  @override
  State<ReadExamplePage> createState() => _ReadExamplePageState();
}

/// State class for [ReadExamplePage] that manages interactions with
/// Firestore for adding, fetching all, and fetching by document ID.
class _ReadExamplePageState extends State<ReadExamplePage>
    implements OperationCheckerService {
  late final OperationRunner runner;

  @override
  void initState() {
    runner = OperationRunner(
        this); // Initialize the operation runner with the service callback
    super.initState();
  }

  /// Callback to handle a failed operation.
  ///
  /// [exception] contains the error message returned by the failed operation.
  @override
  void onFailed(dynamic exception) {
    log("Operation failed: ${exception.toString()}");
  }

  /// Callback to handle a successful operation.
  ///
  /// [message] contains the success message returned by the successful operation.
  @override
  void onSuccess(dynamic message) {
    log("Operation successful: ${message.toString()}");
  }

  /// Callback to handle in progress operation.
  @override
  void inProgress() {
    log("operation in progress");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Operations Example"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text("Add a new document to the Firestore collection:"),
            ),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _onAddDataPressed,
              child: const Text('Add New Document'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text("Fetch all documents from the Firestore collection:"),
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              onPressed: _onFetchAllDocumentsPressed,
              child: const Text('Fetch All Documents'),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text("Fetch a document by its ID:"),
            ),
            MaterialButton(
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: _onFetchByIdPressed,
              child: const Text('Fetch Document by ID'),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles adding a new document to the Firestore collection.
  ///
  /// This method triggers the document saving process using [WriteReposExample],
  /// and the result is passed through the [OperationRunner] for further handling.
  void _onAddDataPressed() {
    WriteReposExample writeReposExample = WriteReposExample();
    // Add a new document with sample data to the Firestore collection
    runner.runOperation(
      writeReposExample
          .saveDocument(data: {"id": const Uuid().v4(), "name": "john"}),
    );
  }

  /// Handles fetching a document from Firestore by its document ID.
  ///
  /// This method uses [ReadReposExample] to retrieve a document by ID and
  /// triggers the operation via [OperationRunner].
  void _onFetchByIdPressed() async {
    ReadReposExample readReposExample = ReadReposExample();

    // Fetch the document by ID from Firestore
    final fetchByIdResult =
        readReposExample.fetchDocumentById(docId: 'id_example');
    runner.runOperation(fetchByIdResult);
  }

  /// Handles fetching all documents from the Firestore collection.
  ///
  /// This method uses [ReadReposExample] to retrieve all documents and
  /// triggers the operation via [OperationRunner].
  void _onFetchAllDocumentsPressed() async {
    ReadReposExample readReposExample = ReadReposExample();

    // Fetch all documents from Firestore
    final fetchAllDocumentsResult = readReposExample.fetchAllDocuments();
    runner.runOperation(fetchAllDocumentsResult);
  }
}

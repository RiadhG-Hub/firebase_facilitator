import 'dart:developer';

import 'package:firebase_facilitator/mixin/helper/operation_runner.dart';
import 'package:firebase_facilitator_example/repository/read_write_repository_example.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// A page widget that demonstrates examples of reading and writing data
/// to and from a Firestore collection using a repository pattern.
///
/// This widget is stateful and interacts with Firebase Firestore
/// through repositories. It displays a user interface for adding,
/// fetching, and deleting documents in a Firestore collection.
/// Operations are handled through an [OperationRunner] class, which
/// facilitates the processing of asynchronous operations and provides
/// feedback through callbacks.
///
/// The UI consists of buttons to trigger Firestore operations such as:
/// - Adding a new document
/// - Fetching all documents
/// - Fetching a document by its ID
/// - Deleting a document
class ReadWriteExamplePage extends StatefulWidget {
  const ReadWriteExamplePage({super.key});

  @override
  State<ReadWriteExamplePage> createState() => _ReadWriteExamplePageState();
}

/// State class for [ReadWriteExamplePage].
///
/// This class manages the interaction with Firestore and UI updates.
/// It uses an instance of [ReadWriteReposExample] to access Firestore data.
/// The [OperationRunner] class helps manage and execute Firestore operations
/// and provides callbacks for handling success and failure scenarios.
///
/// The page includes multiple buttons that allow the user to trigger
/// operations, such as adding, deleting, or fetching documents.
class _ReadWriteExamplePageState extends State<ReadWriteExamplePage>
    implements OperationCheckerService {
  // The repository that handles reading and writing operations on Firestore.
  ReadWriteReposExample readWriteReposExample = ReadWriteReposExample();

  // A helper class that handles asynchronous operations and calls the provided
  // callbacks (onSuccess or onFailed) based on the result.
  late final OperationRunner runner;

  @override
  void initState() {
    // Initialize the OperationRunner with this class as the callback service.
    runner = OperationRunner(this);
    super.initState();
  }

  /// Callback method to handle a failed operation.
  ///
  /// This method is triggered when an operation fails.
  /// [exception] provides details of the error that caused the failure.
  @override
  void onFailed(dynamic exception) {
    log("Operation failed: ${exception.toString()}");
  }

  /// Callback to handle in progress operation.
  @override
  void inProgress() {
    log("operation in progress");
  }

  /// Callback method to handle a successful operation.
  ///
  /// This method is triggered when an operation completes successfully.
  /// [message] provides details of the success message.
  @override
  void onSuccess(dynamic message) {
    log("Operation successful: ${message.toString()}");
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
              child:
                  Text("Click the button below to add data to the collection:"),
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
              child: Text(
                  "Click the button below to delete data from the collection:"),
            ),
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              onPressed: _onDeleteDataPressed,
              child: const Text('Delete Data'),
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

  /// Method triggered when the "Add Data" button is pressed.
  ///
  /// This method calls [ReadWriteReposExample.saveDocument] to add a new
  /// document to Firestore with sample data (a UUID and a name).
  /// The result of the operation is processed via the [OperationRunner],
  /// which will trigger either [onSuccess] or [onFailed] based on the outcome.
  void _onAddDataPressed() {
    runner.runOperation(
      readWriteReposExample
          .saveDocument(data: {"id": const Uuid().v4(), "name": "john"}),
    );
  }

  /// Method triggered when the "Fetch Document by ID" button is pressed.
  ///
  /// This method calls [ReadWriteReposExample.fetchDocumentById] to retrieve
  /// a specific document from Firestore by its document ID. The result is
  /// handled through the [OperationRunner] for success or failure.
  void _onFetchByIdPressed() async {
    final fetchByIdResult =
        readWriteReposExample.fetchDocumentById(docId: 'id_example');
    runner.runOperation(fetchByIdResult);
  }

  /// Method triggered when the "Fetch All Documents" button is pressed.
  ///
  /// This method calls [ReadWriteReposExample.fetchAllDocuments] to retrieve
  /// all documents in the Firestore collection. The result is processed
  /// through the [OperationRunner] for success or failure.
  void _onFetchAllDocumentsPressed() async {
    final fetchAllDocumentsResult = readWriteReposExample.fetchAllDocuments();
    runner.runOperation(fetchAllDocumentsResult);
  }

  /// Method triggered when the "Delete Data" button is pressed.
  ///
  /// This method calls [ReadWriteReposExample.deleteDocument] to delete a
  /// document from the Firestore collection by its document ID. The result is
  /// handled by the [OperationRunner], which will invoke the appropriate callback.
  void _onDeleteDataPressed() {
    runner.runOperation(
        readWriteReposExample.deleteDocument(documentId: 'id_example'));
  }
}

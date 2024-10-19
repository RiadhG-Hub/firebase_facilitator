import 'dart:developer'; // Imports the developer library for logging messages.

import 'package:firebase_facilitator/mixin/helper/operation_runner.dart'; // A utility for handling asynchronous operations.
import 'package:firebase_facilitator_example/repository/storage_repository_example.dart'; // The repository that handles Firebase Storage operations.
import 'package:flutter/material.dart'; // Flutter framework for UI components.

/// A stateful widget that provides an example of Firebase Storage operations (upload, download, delete)
/// using the `StorageRepositoryExample` class and `OperationRunner` for managing asynchronous operations.
class StorageExamplePage extends StatefulWidget {
  const StorageExamplePage({super.key});

  @override
  State<StorageExamplePage> createState() => _StorageExamplePageState();
}

/// The state class for `StorageExamplePage`, implementing the `OperationCheckerService`
/// to handle the success, failure, and progress states of Firebase Storage operations.
class _StorageExamplePageState extends State<StorageExamplePage>
    implements OperationCheckerService {
  // Instance of StorageRepositoryExample to handle Firebase Storage operations.
  StorageRepositoryExample storageRepositoryExample =
      StorageRepositoryExample(StorageService());

  // Helper class to manage asynchronous operations and trigger success or failure callbacks.
  late final OperationRunner runner;

  @override
  void initState() {
    // Initializes the `OperationRunner` and links it with this class to manage operation callbacks.
    runner = OperationRunner(this);
    super.initState();
  }

  /// Callback method to handle failed operations.
  ///
  /// This method is invoked when an operation fails, logging the exception message.
  /// [exception] provides details about the failure.
  @override
  void onFailed(dynamic exception) {
    log("Operation failed: ${exception.toString()}"); // Logs the error message.
  }

  /// Callback method to indicate an operation is in progress.
  ///
  /// This method is called while an asynchronous operation is being processed.
  @override
  void inProgress() {
    log("Operation in progress"); // Logs that the operation is ongoing.
  }

  /// Callback method to handle successful operations.
  ///
  /// This method is called when an operation completes successfully, logging the success message.
  /// [message] contains details of the successful outcome.
  @override
  void onSuccess(dynamic message) {
    log("Operation successful: ${message.toString()}"); // Logs the success message.
  }

  @override
  Widget build(BuildContext context) {
    // Builds the user interface for interacting with Firebase Storage operations.
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Firestore Operations Example"), // The title displayed in the app bar.
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16), // Adds vertical spacing.

          // A labeled section for uploading images.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Upload Image"),
          ),
          MaterialButton(
            color: Colors.orange, // Sets the button color.
            textColor: Colors.white, // Sets the text color.
            onPressed: () {
              // Runs the `uploadFile` operation and manages its state using `OperationRunner`.
              runner.runOperation(
                storageRepositoryExample.uploadFile(),
              );
            },
            child: const Text('Upload Image'), // The button label.
          ),

          const SizedBox(height: 16), // Adds vertical spacing.

          // A labeled section for downloading images.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Download Image"),
          ),
          MaterialButton(
            color: Colors.orange, // Sets the button color.
            textColor: Colors.white, // Sets the text color.
            onPressed: () {
              // Runs the `downloadFile` operation and manages its state using `OperationRunner`.
              runner.runOperation(
                storageRepositoryExample.downloadFile(),
              );
            },
            child: const Text('Download Image'), // The button label.
          ),

          const SizedBox(height: 16), // Adds vertical spacing.

          // A labeled section for deleting images.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Delete Image"),
          ),
          MaterialButton(
            color: Colors.orange, // Sets the button color.
            textColor: Colors.white, // Sets the text color.
            onPressed: () {
              // Runs the `deleteFile` operation and manages its state using `OperationRunner`.
              runner.runOperation(
                storageRepositoryExample.deleteFile(),
              );
            },
            child: const Text('Delete Image'), // The button label.
          ),
        ],
      ),
    );
  }
}

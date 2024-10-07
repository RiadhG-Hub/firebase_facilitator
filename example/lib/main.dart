import 'dart:developer'; // For logging messages.

import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore database interactions.
import 'package:firebase_facilitator/mixin/crud_repos.dart'; // Provides mixins for CRUD operations.
import 'package:firebase_facilitator/mixin/firestore_read_service.dart'; // Mixin for reading Firestore data.
import 'package:firebase_facilitator/mixin/firestore_write_service.dart'; // Mixin for writing Firestore data.
import 'package:firebase_facilitator/mixin/logger_service.dart'; // Mixin for logging services.

void main() {
  // Instantiate the repository and call Firestore operations
  final ReadWriteReposExample repos = ReadWriteReposExample();

  repos.fetchAllDocuments(); // Fetch all documents in the collection.
  repos.fetchDocumentById(docId: "id_example"); // Fetch document by ID.
  repos.deleteDocument(documentId: "id_example"); // Delete document by ID.
  repos.saveDocument(
      data: {"id": "id_example", "fullName": "John"}); // Add a document.
  repos.customOperations(); // Perform custom Firestore queries.
}

/// A class for handling Firestore CRUD operations using mixins from `firebase_facilitator`.
///
/// Combines Firestore read and write capabilities with optional logging for better tracking.
class ReadWriteReposExample
    with FirestoreReadRepository, FirestoreWriteRepository {
  /// Provides Firestore read operations.
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  /// Provides Firestore write operations.
  @override
  FirestoreWriteService get firestoreWriteService =>
      FirestoreWriteServiceImpl();

  /// Optional logging service.
  /// Set to `true` to enable logging, otherwise returns `null`.
  @override
  LoggerService? get loggerService => LoggerServiceImpl(true);

  /// Firestore collection name.
  @override
  String get collection => "collection_example";

  /// A custom Firestore query that fetches documents where "field" is not equal to "something".
  ///
  /// This method demonstrates that you can still use Firebase natively alongside the mixins provided by this repository.
  /// The query is performed directly using the native Firestore API.
  /// After fetching the documents, it logs the number of results found.
  Future<void> customOperations() async {
    final result = await FirebaseFirestore.instance
        .collection(collection)
        .where("field", isNotEqualTo: "something")
        .get();

    log("Found ${result.size} document(s) in the query.");
  }
}

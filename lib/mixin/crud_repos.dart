import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';
import 'firestore_read_service.dart';
import 'firestore_write_service.dart';
import 'logger_service.dart';

mixin FirestoreReadRepository {
  /// The name of the Firestore collection.
  /// This should be overridden by classes that implement this mixin.
  String get collection => '';

  FirestoreReadService get firestoreReadService;

  LoggerService? get loggerService;

  /// Fetches all documents from the Firestore collection.
  ///
  /// This method logs the progress, performs the fetch operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// Returns a Future list of all document data as a List of Maps.
  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    // Log the start of the fetch operation
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching all documents in progress");

    try {
      // Fetch all documents from Firestore
      final documents =
          await firestoreReadService.fetchAllDocuments(collection);
      return documents;
    } catch (e) {
      // Log any error encountered during the fetch
      const errorMessage = 'Error fetching all documents';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the fetch operation
      loggerService?.logCompletionTime(now, 'Fetching all documents');
    }
  }

  /// Fetches a document from Firestore by its ID.
  Future<Map<String, dynamic>?> fetchDocumentById(
      {required String docId}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching document with ID $docId in progress");

    try {
      final result =
          await firestoreReadService.fetchDocumentById(collection, docId);
      return result.data() as Map<String, dynamic>?;
    } catch (e) {
      final errorMessage = 'Error fetching document with ID $docId';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching document');
    }
  }

  /// Fetches paginated documents from the Firestore collection.
  ///
  /// [limit] defines the maximum number of documents to fetch.
  /// [lastDocument] is the last document from the previous page used to fetch the next page.
  ///
  /// Returns a Future containing a Map with the list of documents and the last document fetched.
  Future<Map<String, dynamic>> fetchPaginatedDocuments({
    int limit = 10,
    DocumentSnapshot? lastDocument,
    String orderByField = 'createdAt',
  }) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching paginated documents in progress");

    try {
      Query query = firestoreReadService
          .getCollectionReference(collection)
          .orderBy(orderByField)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      final documents = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Get the last document to use for pagination in the next call
      final lastDoc =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return {
        'documents': documents,
        'lastDocument': lastDoc,
      };
    } catch (e) {
      const errorMessage = 'Error fetching paginated documents';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching paginated documents');
    }
  }
}

/// Mixin for Firestore Write Operations
///
/// This mixin provides functionalities for writing documents
/// to a Firestore collection. It allows for saving and deleting documents,
/// with logging support for tracking the progress and completion of operations.
mixin FirestoreWriteRepository {
  /// The name of the Firestore collection.
  /// This should be overridden by classes that implement this mixin.
  String get collection => '';

  /// Instance of FirestoreWriteService used to perform write operations.
  FirestoreWriteService get firestoreWriteService;

  /// Optional LoggerService for logging events, errors, and timing.
  LoggerService? get loggerService;

  /// Saves a document to Firestore.
  ///
  /// This method logs the progress, performs the save operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// [data]: The document data to be saved as a Map.
  ///
  /// Returns a Future that completes when the document is saved.
  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    // Log the start of the save operation
    final now = DateTime.now();
    loggerService?.log("⌛ Saving document: $data in progress");

    try {
      // Save document to Firestore
      await firestoreWriteService.saveDocument(collection, data);
      // Log the success of the operation
      loggerService?.log(
          '✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      // Log any error encountered during the save
      const errorMessage = 'Error saving document';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the save operation
      loggerService?.logCompletionTime(now, 'Saving document');
    }
  }

  /// Deletes a document from Firestore by its ID.
  ///
  /// This method logs the progress, performs the delete operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// [documentId]: The ID of the document to delete.
  ///
  /// Returns a Future that completes when the document is deleted.
  Future<void> deleteDocument({required String documentId}) async {
    // Log the start of the delete operation
    final now = DateTime.now();
    loggerService?.log("⌛ Deleting document with ID $documentId in progress");

    try {
      // Delete document from Firestore
      await firestoreWriteService.deleteDocument(collection, documentId);
      // Log the success of the operation
      loggerService?.log('✅ Document with ID $documentId deleted successfully');
    } catch (e) {
      // Log any error encountered during the delete
      final errorMessage = 'Error deleting document with ID $documentId';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the delete operation
      loggerService?.logCompletionTime(now, 'Deleting document');
    }
  }
}

/// Mixin for Authentication Operations
///
/// This mixin provides functionalities for checking the user's
/// authentication status. It ensures that the user is authenticated
/// before proceeding with any operations.
mixin AuthRepository {
  /// Instance of AuthService used to check authentication status.
  AuthService get authService;

  /// Ensures the user is authenticated.
  ///
  /// If the user is not authenticated, an exception is thrown.
  ///
  /// Returns a Future that completes if the user is authenticated.
  Future<void> checkAuthenticated() async {
    // Check if the user is authenticated
    if (!authService.isAuthenticated()) {
      // Throw an exception if the user is not authenticated
      throw Exception('User not authenticated');
    }
  }
}

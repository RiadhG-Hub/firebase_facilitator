import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// Abstract class for Firestore read operations.
abstract class FirestoreReadService {
  /// Fetches a document from Firestore by its ID.
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      String collection, String docId);

  /// Fetches all documents from the specified Firestore collection.
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection);

  /// Returns the collection reference for Firestore queries.
  Query getCollectionReference(String collection);
}

/// Base implementation of FirestoreReadService.
class FirestoreReadServiceBase implements FirestoreReadService {
  final FirebaseFirestore firestore;

  FirestoreReadServiceBase(this.firestore);

  @override
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      String collection, String docId) {
    return firestore.collection(collection).doc(docId).get();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection) async {
    final snapshot = await firestore.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Query getCollectionReference(String collection) {
    return firestore.collection(collection);
  }
}

/// Production implementation using FirebaseFirestore.
class FirestoreServiceImpl extends FirestoreReadServiceBase {
  FirestoreServiceImpl() : super(FirebaseFirestore.instance);
}

/// Fake implementation using FakeFirebaseFirestore.
class FakeFirestoreServiceImpl extends FirestoreReadServiceBase {
  FakeFirestoreServiceImpl() : super(FakeFirebaseFirestore());
}

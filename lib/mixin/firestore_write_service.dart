import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// Abstract class for Firestore write operations.
abstract class FirestoreWriteService {
  /// Saves a document to the specified Firestore collection.
  Future<void> saveDocument(String collection, Map<String, dynamic> data);

  /// Deletes a document from the specified Firestore collection.
  Future<void> deleteDocument(String collection, String documentId);
}

/// Base implementation of FirestoreWriteService.
class FirestoreWriteServiceBase implements FirestoreWriteService {
  final FirebaseFirestore firestore;

  FirestoreWriteServiceBase(this.firestore);

  @override
  Future<void> saveDocument(String collection, Map<String, dynamic> data) async {
    final docRef = firestore.collection(collection).doc(data['id']);
    await docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteDocument(String collection, String documentId) async {
    await firestore.collection(collection).doc(documentId).delete();
  }
}

/// Production implementation using FirebaseFirestore.
class FirestoreWriteServiceImpl extends FirestoreWriteServiceBase {
  FirestoreWriteServiceImpl() : super(FirebaseFirestore.instance);
}

/// Fake implementation using FakeFirebaseFirestore.
class FakeFirestoreWriteServiceImpl extends FirestoreWriteServiceBase {
  FakeFirestoreWriteServiceImpl() : super(FakeFirebaseFirestore());
}

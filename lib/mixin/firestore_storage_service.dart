import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

/// Services for Firebase Storage Operations
///
/// This mixin defines the interface for handling basic Firebase Storage operations,
/// including uploading files, downloading files, and deleting files.
mixin FirebaseStorageService {
  final fakeStorage = MockFirebaseStorage();

  /// Uploads a file to Firebase Storage.
  ///
  /// [filePath]: The local path of the file to upload.
  /// Example: `/local/path/to/file.jpg`
  ///
  /// [storagePath]: The path in Firebase Storage where the file should be uploaded.
  /// Example: `uploads/images/file.jpg`
  ///
  /// Returns a Future that resolves to the download URL of the uploaded file.
  Future<String> uploadFile({
    required String filePath,
    required String storagePath,
    bool useFake = false,
  }) async {
    final file = File(filePath);
    final storageReference = useFake
        ? fakeStorage.ref(storagePath)
        : FirebaseStorage.instance.ref(storagePath);

    final uploadTask = await storageReference.putFile(file);
    return uploadTask.ref.getDownloadURL();
  }

  /// Downloads a file from Firebase Storage.
  ///
  /// [storagePath]: The path in Firebase Storage of the file to download.
  /// Example: `uploads/images/file.jpg`
  ///
  /// [destinationPath]: The local path where the file should be saved.
  /// Example: `/local/path/to/download/file.jpg`
  ///
  /// Returns a Future that resolves once the file has been downloaded and saved locally.
  Future<void> downloadFile({
    required String storagePath,
    required String destinationPath,
    bool useFake = false,
  }) async {
    final downloadToFile = File(destinationPath);
    final storageReference = useFake
        ? fakeStorage.ref(storagePath)
        : FirebaseStorage.instance.ref(storagePath);

    await storageReference.writeToFile(downloadToFile);
  }

  /// Deletes a file from Firebase Storage.
  ///
  /// [storagePath]: The path in Firebase Storage of the file to delete.
  /// Example: `uploads/images/file.jpg`
  ///
  /// Returns a Future that resolves once the file has been deleted.
  Future<void> deleteFile({
    required String storagePath,
    bool useFake = false,
  }) async {
    final storageReference = useFake
        ? fakeStorage.ref(storagePath)
        : FirebaseStorage.instance.ref(storagePath);

    await storageReference.delete();
  }
}

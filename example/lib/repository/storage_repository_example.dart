import 'dart:developer'; // Imports the developer library for logging messages to the console.

import 'package:file_picker/file_picker.dart'; // Provides utilities to select and pick files from the device.
import 'package:firebase_facilitator/mixin/firestore_storage_service.dart'; // Imports the Firebase storage service mixin.

// A service class that implements Firebase storage operations using the FirebaseStorageService mixin.
class StorageService with FirebaseStorageService {}

// The StorageRepositoryExample class demonstrates uploading, downloading, and deleting files using Firebase Storage.
class StorageRepositoryExample {
  static const String imagePath =
      "image_folder"; // Specifies the Firebase Storage folder path.
  final StorageService
      storageService; // An instance of StorageService to handle storage operations.

  // Constructor to initialize the repository with the required storage service.
  StorageRepositoryExample(this.storageService);

  /// Uploads a file to Firebase Storage and logs the resulting URL.
  ///
  /// This method allows the user to select an image from their device, and then uploads
  /// the selected file to Firebase Storage under the specified `imagePath` folder.
  ///
  /// If the upload is successful, it logs the URL of the uploaded file. If there are any errors during
  /// the upload process, it logs the error message.
  Future<void> uploadFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return; // Exit if no file is selected.

    final String? filePath = result.paths.firstOrNull;
    if (filePath == null) return; // Exit if no valid file path is provided.

    try {
      // Uploads the selected file to Firebase Storage and logs the download URL.
      final String imageUrl = await storageService.uploadFile(
        filePath: filePath,
        storagePath:
            "$imagePath/file.jpg", // The path where the file will be stored in Firebase Storage.
      );
      log('File uploaded successfully. URL: $imageUrl'); // Logs the URL of the uploaded file.
    } catch (e) {
      log('Error uploading file: $e'); // Logs any errors encountered during the upload.
    }
  }

  /// Downloads a file from Firebase Storage to a local directory.
  ///
  /// This method allows the user to select a local directory, then downloads the file from
  /// Firebase Storage to the selected directory. It logs a success message when the file is
  /// downloaded or an error message if any issue occurs.
  Future<void> downloadFile() async {
    final String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) return; // Exit if no directory is selected.

    try {
      // Downloads the file from Firebase Storage to the specified local directory.
      await storageService.downloadFile(
        storagePath:
            "$imagePath/file.jpg", // The path of the file in Firebase Storage.
        destinationPath:
            "$directoryPath/file.jpg", // The local path where the file will be saved.
      );
      log('File downloaded successfully'); // Logs a success message when the file is downloaded.
    } catch (e) {
      log('Error downloading file: $e'); // Logs any errors encountered during the download.
    }
  }

  /// Deletes a file from Firebase Storage.
  ///
  /// This method deletes the file located at the specified `storagePath` in Firebase Storage.
  /// It logs a success message upon successful deletion or an error message if the deletion fails.
  Future<void> deleteFile() async {
    try {
      // Deletes the file from Firebase Storage.
      await storageService.deleteFile(storagePath: "$imagePath/file.jpg");
      log('File deleted successfully'); // Logs a success message when the file is deleted.
    } catch (e) {
      log('Error deleting file: $e'); // Logs any errors encountered during deletion.
    }
  }
}

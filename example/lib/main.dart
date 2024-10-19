import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_facilitator/mixin/crud_repos.dart';
import 'package:firebase_facilitator/mixin/firestore_read_service.dart';
import 'package:firebase_facilitator/mixin/firestore_storage_service.dart';
import 'package:firebase_facilitator/mixin/firestore_write_service.dart';
import 'package:firebase_facilitator/mixin/logger_service.dart';

/// `ItemFirestoreService` handles Firestore CRUD operations for the "items" collection,
/// integrating logging and Firebase storage services.
class ItemFirestoreService
    with
        FirestoreReadRepository,
        FirestoreWriteRepository,
        FirebaseStorageService {
  /// Provides the Firestore read service for fetching data.
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  /// Provides the Firestore write service for saving and deleting data.
  @override
  FirestoreWriteService get firestoreWriteService =>
      FirestoreWriteServiceImpl();

  /// Optional logging service for tracking operations.
  @override
  LoggerService? get loggerService =>
      LoggerServiceImpl(true); // Set to enable/disable logging

  /// Specifies the Firestore collection name.
  @override
  String get collection => "items";
}

/// Provides methods for interacting with `ItemModel` objects in Firestore.
class ItemRepository {
  static const String imagePath = "image_folder";
  final ItemFirestoreService firestoreService;

  /// Requires an `ItemFirestoreService` instance.
  ItemRepository(this.firestoreService);

  /// Fetches all items from Firestore and returns them as a list of `ItemModel`.
  Future<List<ItemModel>> fetchAllItems() async {
    try {
      final List<Map<String, dynamic>> rawData =
          await firestoreService.fetchAllDocuments();
      return rawData.map((element) => ItemModel.fromJson(element)).toList();
    } catch (e) {
      log('Error fetching items: $e');
      rethrow; // Propagate the error for further handling
    }
  }

  /// Saves a new `ItemModel` to Firestore.
  Future<void> saveItem({required ItemModel itemModel}) async {
    try {
      await firestoreService.saveDocument(data: itemModel.toJson());
    } catch (e) {
      log('Error saving item: $e');
    }
  }

  /// Fetches a single `ItemModel` by its ID from Firestore.
  Future<ItemModel> fetchItemByID({required String itemId}) async {
    try {
      final Map<String, dynamic>? rawData =
          await firestoreService.fetchDocumentById(docId: itemId);
      if (rawData == null) throw Exception("Item not found");
      return ItemModel.fromJson(rawData);
    } catch (e) {
      log('Error fetching item by ID: $e');
      rethrow;
    }
  }

  /// Deletes an item from Firestore by its ID.
  Future<void> deleteItem({required String id}) async {
    try {
      await firestoreService.deleteDocument(documentId: id);
    } catch (e) {
      log('Error deleting item: $e');
    }
  }

  /// Uploads a file to Firebase Storage and logs the resulting URL.
  Future<void> uploadFile() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return; // No file selected

    final String? filePath = result.paths.firstOrNull;
    if (filePath == null) return;

    try {
      final String imageUrl = await firestoreService.uploadFile(
        filePath: filePath,
        storagePath: "$imagePath/file.jpg",
      );
      log('File uploaded successfully. URL: $imageUrl');
    } catch (e) {
      log('Error uploading file: $e');
    }
  }

  /// Downloads a file from Firebase Storage to a local directory.
  Future<void> downloadFile() async {
    final String? directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) return;

    try {
      await firestoreService.downloadFile(
        storagePath: "$imagePath/file.jpg",
        destinationPath: "$directoryPath/file.jpg",
      );
      log('File downloaded successfully');
    } catch (e) {
      log('Error downloading file: $e');
    }
  }

  /// Deletes a file from Firebase Storage.
  Future<void> deleteFile() async {
    try {
      await firestoreService.deleteFile(storagePath: "$imagePath/file.jpg");
      log('File deleted successfully');
    } catch (e) {
      log('Error deleting file: $e');
    }
  }
}

/// Represents an item with `id`, `name`, and `price` fields.
class ItemModel {
  final String id;
  final String name;
  final double price;

  /// Constructor to create an `ItemModel`.
  ItemModel({required this.id, required this.name, required this.price});

  /// Creates an `ItemModel` from JSON.
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  /// Converts `ItemModel` to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

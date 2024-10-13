import 'package:firebase_facilitator/mixin/crud_repos.dart';
import 'package:firebase_facilitator/mixin/firestore_read_service.dart';
import 'package:firebase_facilitator/mixin/firestore_write_service.dart';
import 'package:firebase_facilitator/mixin/logger_service.dart';

/// `ItemFirestoreService` handles Firestore CRUD operations for the "items" collection.
/// It uses the `FirestoreReadRepository` and `FirestoreWriteRepository` mixins to
/// perform read and write operations, and it provides a logging service for
/// optional operation logging.
class ItemFirestoreService with FirestoreReadRepository, FirestoreWriteRepository {
  /// The Firestore read service implementation, responsible for fetching data from Firestore.
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  /// The Firestore write service implementation, responsible for saving and deleting data in Firestore.
  @override
  FirestoreWriteService get firestoreWriteService => FirestoreWriteServiceImpl();

  /// The logger service to track operations. Here it's set to `true`, enabling logging.
  @override
  LoggerService? get loggerService => LoggerServiceImpl(true); // Optional

  /// The Firestore collection name that this service operates on.
  @override
  String get collection => "items";
}

/// `ItemRepository` acts as an abstraction layer over the Firestore service,
/// providing specific methods to interact with `ItemModel` objects in the Firestore
/// collection.
class ItemRepository {
  final ItemFirestoreService firestoreService;

  /// Constructor that requires an instance of `ItemFirestoreService` to be passed in.
  ItemRepository(this.firestoreService);

  /// Fetches all items from the "items" collection.
  ///
  /// The method retrieves the raw data from Firestore, converts each document
  /// into a JSON object, and then maps it to a list of `ItemModel` objects.
  Future<List<ItemModel>> fetchAllItems() async {
    final List<Map<String, dynamic>> rawData = await firestoreService.fetchAllDocuments();
    // Convert the Firestore document data into a list of `ItemModel` objects.
    return rawData.map((element) => ItemModel.fromJson(element)).toList();
  }

  /// Saves a new item to the "items" collection.
  ///
  /// This method converts the given `ItemModel` object to a JSON format
  /// and then saves it to Firestore using the `saveDocument` method.
  Future<void> saveItem({required ItemModel itemModel}) async {
    firestoreService.saveDocument(data: itemModel.toJson());
  }

  /// Fetches a single item by its document ID from the "items" collection.
  ///
  /// The method retrieves the document with the given `itemId`, asserts that it exists,
  /// and then converts it from JSON into an `ItemModel` object.
  Future<ItemModel> fetchItemByID({required String itemId}) async {
    final Map<String, dynamic>? rawData = await firestoreService.fetchDocumentById(docId: itemId);
    assert(rawData != null, "we can't find the item for you");
    return ItemModel.fromJson(rawData!);
  }

  /// Deletes an item by its document ID from the "items" collection.
  ///
  /// The method uses the `deleteDocument` method from the Firestore service to remove
  /// the document with the specified `id`.
  Future<void> deleteItem({required String id}) async {
    firestoreService.deleteDocument(documentId: id);
  }
}

/// `ItemModel` represents an item in the "items" collection, with fields for `id`, `name`,
/// and `price`.
class ItemModel {
  final String id;
  final String name;
  final double price;

  /// Constructor to create an `ItemModel` object with the required fields.
  ItemModel({
    required this.id,
    required this.name,
    required this.price,
  });

  /// Factory constructor to create an `ItemModel` from a JSON object.
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(), // Ensure the price is converted to a double.
    );
  }

  /// Converts an `ItemModel` object into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

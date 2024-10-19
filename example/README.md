

# firebase\_facilitator

[![pub package version](https://img.shields.io/pub/v/firebase_facilitator.svg)](https://pub.dev/packages/firebase_facilitator) [![pub points](https://img.shields.io/pub/points/firebase_facilitator?color=2E8B57&label=pub%20points)](https://pub.dev/packages/firebase_facilitator/score) [![CodeFactor](https://www.codefactor.io/repository/github/riadhg-hub/firebase_facilitator/badge)](https://www.codefactor.io/repository/github/riadhg-hub/firebase_facilitator)


**firebase\_facilitator** is a versatile package that streamlines CRUD operations with Firestore in Flutter applications. It provides mixins for handling common tasks like Create, Read, Update, and Delete, along with optional logging functionality.

## Platform Support

| Android | iOS | Web | macOS | Windows | Linux |
| --- | --- | --- | --- | --- | --- |
| ✅   | ✅   | ✅   | ✅   | ✅   | ✅   |

## Requirements

*   Flutter >= 3.3.0
*   `cloud_firestore: ^5.4.4`
*   `fake_cloud_firestore: ^3.0.3`
*   `firebase_auth: ^5.3.1` (optional, for authentication)
*   `firebase_core: ^3.6.0`
*   `logger: ^2.4.0` (optional, for logging)

## Usage

In this video, we demonstrate how to streamline Firestore CRUD operations in Flutter using the firebase_facilitator package. Learn how to quickly implement Firestore read and write functionality, as well as optional logging, with just a few lines of code. Watch as we create a service to fetch all documents from a Firestore collection and convert them into model objects. This package helps save time and effort, making your Firestore integration more efficient.

[![Everything Is AWESOME](https://i9.ytimg.com/vi_webp/pReLQ-5sTaE/mq2.webp?sqp=CJjOqbgG-oaymwEmCMACELQB8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGEsgZShRMA8=&rs=AOn4CLCYyC5yXhKLpiUNef_6jo8QjPa5BQ)](https://www.youtube.com/playlist?list=PLUSagxHszGmP4O3RoNo4C6A9-zK0i37Ql "Everything Is AWESOME")

To use the **firebase\_facilitator** package, simply import the necessary mixins and integrate them into your data repository class for seamless Firestore operations.

```dart
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

```


`ItemRepository` acts as an abstraction layer over the Firestore service,
providing specific methods to interact with `ItemModel` objects in the Firestore
collection.

```dart

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


```

`ItemModel` represents an item in the "items" collection, with fields for `id`, `name`,
and `price`.

```dart
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


```




The `ReadWriteReposExample` class handles Firestore operations like adding, fetching, and deleting documents, allowing developers to focus on business logic while abstracting the complexity of Firestore.
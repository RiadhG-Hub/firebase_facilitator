import 'package:firebase_facilitator/mixin/crud_repos.dart';
import 'package:firebase_facilitator/mixin/firestore_read_service.dart';
import 'package:firebase_facilitator/mixin/firestore_write_service.dart';
import 'package:firebase_facilitator/mixin/logger_service.dart';

class ReadWriteReposExample
    with FirestoreReadRepository, FirestoreWriteRepository {
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  @override
  FirestoreWriteService get firestoreWriteService =>
      FirestoreWriteServiceImpl();

  @override
  LoggerService? get loggerService => LoggerServiceImpl(true);
  @override
  String get collection => "collection_example";
}

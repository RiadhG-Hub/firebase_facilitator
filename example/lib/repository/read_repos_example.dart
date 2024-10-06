import 'package:firebase_facilitator/mixin/crud_repos.dart';
import 'package:firebase_facilitator/mixin/firestore_read_service.dart';
import 'package:firebase_facilitator/mixin/logger_service.dart';

class ReadReposExample with FirestoreReadRepository {
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  @override
  LoggerService? get loggerService => LoggerServiceImpl(true);
  @override
  String get collection => "collection_example";
}

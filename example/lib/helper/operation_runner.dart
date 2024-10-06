/// Interface to define callbacks for operation success and failure.
///
/// This is used to communicate between the [OperationRunner] and the page that
/// initiates Firestore operations.
abstract class OperationCheckerService {
  /// Called when an operation completes successfully.
  ///
  /// [message] is a description of the successful operation.
  void onSuccess(String message);

  /// Called when an operation fails.
  ///
  /// [exception] contains the error message from the failed operation.
  void onFailed(String exception);
}

/// Helper class to manage the execution of asynchronous Firestore operations.
///
/// This class runs an operation and communicates the result (success or failure)
/// back to the [OperationCheckerService].
class OperationRunner {
  final OperationCheckerService _operationCheckerService;

  OperationRunner(this._operationCheckerService);

  /// Executes the given [operation], which is a [Future] representing an asynchronous task.
  ///
  /// If the operation succeeds, [onSuccess] is called; otherwise, [onFailed] is triggered.
  void runOperation(Future<dynamic> operation) {
    operation.then((result) {
      _operationCheckerService.onSuccess(result ?? "Operation completed successfully");
    }).catchError((error) {
      _operationCheckerService.onFailed("Operation failed with error: ${error.toString()}");
    });
  }
}

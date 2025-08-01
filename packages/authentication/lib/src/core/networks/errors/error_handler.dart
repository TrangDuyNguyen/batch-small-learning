import 'errors_module.dart';

abstract class ErrorHandler {
  Future<Failure> handle(dynamic exception, [StackTrace? stackTrace]);
  void log(Failure failure, [StackTrace? stackTrace]);
}

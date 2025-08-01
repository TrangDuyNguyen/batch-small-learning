import '../../errors/errors_module.dart';

enum FailureType {
  network, // HTTP errors
  api, // Business errors
  connection, // Connection failures
  timeout, // Request timeouts
  unknown, // Other errors
}

class Result<T> extends Either<NetworkFailure, T> {
  final Either<NetworkFailure, T> either;
  Result._(this.either) : super();

  // Success factory
  factory Result.success(T value) {
    return Result._(Right<NetworkFailure, T>(value));
  }

  // General failure factory
  factory Result.fails(Failure failure) {
    return Result._(
      Left<NetworkFailure, T>(NetworkFailure.fromFailure(failure)),
    );
  }

  factory Result.failsAsError(Object error) {
    return Result.fails(Failure.from(error));
  }

  // Network-specific failure factories
  factory Result.networkError({
    required int statusCode,
    String? message,
    Object? error,
    Map<String, dynamic>? extras,
  }) {
    return Result._(
      Left(
        NetworkFailure.network(
          statusCode: statusCode,
          message: message ?? 'Network error: $statusCode',
          error: error,
          extras: extras,
        ),
      ),
    );
  }

  factory Result.connectionError([String? message]) {
    return Result._(Left(NetworkFailure.connection(message)));
  }

  factory Result.timeoutError([String? message]) {
    return Result._(Left(NetworkFailure.timeout(message)));
  }

  factory Result.apiError(
    AppErrorCode code, [
    String? message,
    Map<String, dynamic>? extras,
  ]) {
    return Result._(
      Left(
        NetworkFailure.api(
          code: code,
          message: message ?? code.defaultMessage,
          extras: extras,
        ),
      ),
    );
  }

  // Standard Either methods
  @override
  B fold<B>(
    B Function(NetworkFailure failure) ifLeft,
    B Function(T value) ifRight,
  ) {
    return either.fold(ifLeft, ifRight);
  }

  // Helper methods
  T? getOrNull() => either.fold((_) => null, (value) => value);
  T getOrThrow() => either.fold((failure) => throw failure, (value) => value);

  // Pattern matching helper
  R when<R>({
    required R Function(T value) success,
    required R Function(NetworkFailure failure) failure,
  }) {
    return fold(failure, success);
  }

  // Enhanced pattern matching with error type differentiation
  R match<R>({
    required R Function(T value) success,
    required R Function(int statusCode, String message) httpError,
    required R Function(AppErrorCode code, String message) apiError,
    required R Function(String message) connectionError,
  }) {
    return fold((failure) {
      if (failure.isConnectionError) {
        return connectionError(failure.message);
      } else if (failure.isApiError) {
        return apiError(failure.apiErrorCode!, failure.message);
      } else {
        return httpError(failure.statusCode, failure.message);
      }
    }, success);
  }

  @override
  Result<E> map<E>(E Function(T value) f) {
    return either.fold(
      (failure) => Result.fails(failure),
      (value) => Result.success(f(value)),
    );
  }

  // Helper properties
  bool get isSuccess => either.isRight();
  bool get isFailure => either.isLeft();
  bool get isNetworkError => isFailure && failure!.isNetworkError;
  bool get isApiError => isFailure && failure!.isApiError;
  bool get isConnectionError => isFailure && failure!.isConnectionError;

  NetworkFailure? get failure => either.fold((failure) => failure, (_) => null);
  T? get value => either.fold((_) => null, (value) => value);
}

// Enhanced failure class with network status
class NetworkFailure extends Failure {
  final int statusCode;
  final FailureType type;
  final AppErrorCode? apiErrorCode;
  final Object? error;

  NetworkFailure({
    required super.errorCode,
    required this.statusCode,
    required this.type,
    required super.message,
    this.apiErrorCode,
    this.error,
    Map<String, dynamic>? extras,
  }) : super(errorsMetadata: extras ?? {});

  // Network error (HTTP)
  factory NetworkFailure.network({
    required int statusCode,
    required String message,
    Object? error,
    Map<String, dynamic>? extras,
  }) {
    return NetworkFailure(
      errorCode: AppErrorCode.NETWORK_ERROR,
      statusCode: statusCode,
      type: FailureType.network,
      message: message,
      error: error,
      extras: extras ?? {},
    );
  }

  // Connection error
  factory NetworkFailure.connection([String? message]) {
    return NetworkFailure(
      errorCode: AppErrorCode.CONNECTION_ERROR,
      statusCode: 0,
      type: FailureType.connection,
      message: message ?? 'Connection error',
    );
  }

  // Timeout error
  factory NetworkFailure.timeout([String? message]) {
    return NetworkFailure(
      errorCode: AppErrorCode.CONNECTION_ERROR,
      statusCode: 0,
      type: FailureType.timeout,
      message: message ?? 'Request timed out',
    );
  }

  // API error (business logic)
  factory NetworkFailure.api({
    required AppErrorCode code,
    String? message,
    Map<String, dynamic>? extras,
  }) {
    return NetworkFailure(
      errorCode: code,
      statusCode: 0, // No HTTP status for business errors
      type: FailureType.api,
      apiErrorCode: code,
      message: message ?? code.defaultMessage,
      extras: extras,
    );
  }

  /// unknown error
  factory NetworkFailure.unknown({
    required String message,
    required Object error,
  }) {
    return NetworkFailure(
      errorCode: AppErrorCode.UNEXPECTED_ERROR,
      statusCode: 0,
      type: FailureType.unknown,
      message: message,
      error: error,
    );
  }

  // Convert from standard Failure
  factory NetworkFailure.fromFailure(Failure failure) {
    if (failure is NetworkFailure) return failure;

    // Try to determine failure type from error code
    final code = failure.errorCode;
    if (code == AppErrorCode.CONNECTION_ERROR) {
      return NetworkFailure.connection(failure.message);
    } else if (code == AppErrorCode.NETWORK_ERROR) {
      return NetworkFailure.network(
        statusCode: -1,
        message: failure.message,
        extras: failure.errorsMetadata,
      );
    } else if (code is AppErrorCode) {
      return NetworkFailure.api(
        code: code,
        message: failure.message,
        extras: failure.errorsMetadata,
      );
    } else {
      return NetworkFailure(
        errorCode: AppErrorCode.UNEXPECTED_ERROR,
        statusCode: -1,
        type: FailureType.unknown,
        message: failure.message,
        extras: failure.errorsMetadata,
      );
    }
  }

  bool get isNetworkError => type == FailureType.network;
  bool get isApiError => type == FailureType.api;
  bool get isConnectionError => type == FailureType.connection;
  bool get isTimeoutError => type == FailureType.timeout;
}

// import 'package:core/core.dart';

// @Deprecated('Use NetworkResult instead')
// class Result<T> extends Either<Failure, T> {
//   final Either<Failure, T> either;
//   Result._(this.either) : super();

//   factory Result.success(T value) {
//     return Result._(Right<Failure, T>(value));
//   }

//   factory Result.fails(Failure failure) {
//     return Result._(Left<Failure, T>(failure));
//   }

//   factory Result.failsAsError(Object error) {
//     return Result.fails(Failure.from(error));
//   }

//   @override
//   B fold<B>(
//     B Function(Failure l) ifLeft,
//     B Function(T r) ifRight,
//   ) {
//     return either.fold(ifLeft, ifRight);
//   }

//   T? getOrNull() {
//     return either.fold((failure) => null, (value) => value);
//   }

//   T getOrThrow() {
//     return either.fold((failure) => throw failure, (value) => value);
//   }

//   @override
//   Result<E> map<E>(E Function(T value) f) {
//     return either.fold(
//       (failure) => Result.fails(failure),
//       (value) => Result.success(f(value)),
//     );
//   }

//   bool get isSuccess => either.isRight();

//   bool get isFailure => either.isLeft();

//   Failure? get failure => either.fold((failure) => failure, (value) => null);

//   T? get value => either.fold((failure) => null, (value) => value);

//   Either<Failure, T> getEither() {
//     return either;
//   }
// }

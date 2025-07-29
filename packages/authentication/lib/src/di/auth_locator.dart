import 'package:get_it/get_it.dart';

import '../../authentication.dart';

final sl = GetIt.instance;

void setupAuthLocator() {
  sl.registerLazySingleton(() => DioClient().instance);
  // sl.registerLazySingleton(() => AuthService(sl()));
  // sl.registerLazySingleton(() => AuthRepositoryImpl(sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
}
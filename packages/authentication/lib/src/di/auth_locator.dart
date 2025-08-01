import 'package:get_it/get_it.dart';

import '../../authentication_module.dart';

final sl = GetIt.instance;

void setupAuthLocator() {
  // sl.registerLazySingleton(() => AuthService(sl()));
  // sl.registerLazySingleton(() => AuthRepositoryImpl(sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
}
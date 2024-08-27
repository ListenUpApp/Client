import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';

import 'auth/data/auth_repository.dart';
import 'auth/data/datasource/auth_remote_datasource.dart';
import 'auth/data/token_storage.dart';
import 'auth/domain/usecase/login_usecase.dart';
import 'auth/domain/usecase/ping_usecase.dart';
import 'auth/domain/usecase/register_usecase.dart';
import 'core/data/config/config_service.dart';
import 'core/data/network/client_factory.dart';

final sl = GetIt.instance;

Future<void> init() async {
  const storage = FlutterSecureStorage();
  sl.registerLazySingleton<ConfigService>(() => ConfigService());
  sl.registerLazySingleton<GrpcClientFactory>(
      () => GrpcClientFactory(sl<ConfigService>()));
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(sl<AuthRemoteDatasource>(), sl<TokenStorage>()));
  sl.registerLazySingleton<UrlBloc>(
      () => UrlBloc(sl<AuthRepository>(), sl<ConfigService>()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => PingUsecase(sl()));
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(sl<GrpcClientFactory>()));
  sl.registerLazySingleton<TokenStorage>(
      () => TokenStorage(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:listenup/auth/data/datasource/auth_local_datasource.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/core/data/server/datasource/server_remote_datasource.dart';
import 'package:listenup/core/data/server/server_repository.dart';
import 'package:listenup/library/data/datasource/library_remote_datasource.dart';
import 'package:listenup/library/data/library_repository.dart';

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
  sl.registerLazySingleton<ConfigService>(
      () => ConfigService(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<GrpcClientFactory>(
      () => GrpcClientFactory(sl<ConfigService>()));
  sl.registerLazySingleton<ServerRepository>(
      () => ServerRepository(sl<ServerRemoteDatasource>()));
  sl.registerLazySingleton<ServerRemoteDatasource>(
      () => ServerRemoteDatasource(sl<GrpcClientFactory>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(
      sl<AuthRemoteDatasource>(),
      sl<TokenStorage>(),
      sl<AuthLocalDatasource>()));
  sl.registerLazySingleton<UrlBloc>(
      () => UrlBloc(sl<AuthRepository>(), sl<ConfigService>(), sl<AuthBloc>()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(
      authRepository: sl(), serverRepository: sl(), configService: sl()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => PingUsecase(sl()));
  sl.registerLazySingleton<LibraryRepository>(
      () => LibraryRepository(sl<LibraryRemoteDatasource>()));
  sl.registerLazySingleton<LibraryRemoteDatasource>(
      () => LibraryRemoteDatasource(sl<GrpcClientFactory>()));
  sl.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(sl(), sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(sl<GrpcClientFactory>()));
  sl.registerLazySingleton<TokenStorage>(
      () => TokenStorage(sl<FlutterSecureStorage>()));
  sl.registerLazySingleton<FlutterSecureStorage>(() => storage);
}

import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../../core/domain/errors/failure.dart';
import '../../core/domain/types.dart';
import '../domain/auth_repository.dart';
import '../domain/datasource/auth_remote_datasource.dart';
import '../domain/token_storage.dart';

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource _authRemoteDataSource;
  final ITokenStorage _tokenStorage;
  AuthRepository(this._authRemoteDataSource, this._tokenStorage);

  @override
  ResultFuture<PingResponse> pingServer({required PingRequest request}) async {
    try {
      final response = await _authRemoteDataSource.pingServer();
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<LoginResponse> loginUser({required LoginRequest request}) async {
    try {
      final response = await _authRemoteDataSource.loginUser(request);
      _tokenStorage.saveToken(response.accessToken);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<RegisterResponse> registerUser(
      {required RegisterRequest request}) async {
    try {
      final response = await _authRemoteDataSource.registerUser(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

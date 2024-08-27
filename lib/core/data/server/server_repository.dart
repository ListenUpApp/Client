import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/core/domain/server/datasource/server_remote_datasource.dart';
import 'package:listenup/core/domain/server/server_repository.dart';
import 'package:listenup/core/domain/types.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

class ServerRepository implements IServerRepository {
  final IServerRemoteDataSource _serverRemoteDataSource;

  ServerRepository(this._serverRemoteDataSource);
  @override
  ResultFuture<GetServerResponse> getServer(
      {required GetServerRequest request}) async {
    try {
      final response = await _serverRemoteDataSource.getServer(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

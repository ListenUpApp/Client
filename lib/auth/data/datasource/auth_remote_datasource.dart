import 'package:listenup/core/domain/network/client_factory.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../../domain/datasource/auth_remote_datasource.dart';

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final IGrpcClientFactory _clientFactory;

  AuthRemoteDatasource(this._clientFactory);
  @override
  Future<LoginResponse> loginUser(LoginRequest request) async {
    final client = _clientFactory.getAuthServiceClient();
    final response = await client.login(request);
    return response;
  }

  @override
  Future<PingResponse> pingServer() async {
    final client = _clientFactory.getServerServiceClient();
    final request = PingRequest();
    final response = await client.ping(request);
    return response;
  }

  @override
  Future<RegisterResponse> registerUser(RegisterRequest request) async {
    final client = _clientFactory.getAuthServiceClient();
    final response = await client.register(request);
    return response;
  }
}

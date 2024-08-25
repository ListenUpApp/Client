import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

abstract class IAuthRemoteDataSource {
  Future<PingResponse> pingServer();
  Future<LoginResponse> loginUser(LoginRequest request);
  Future<RegisterResponse> registerUser(RegisterRequest request);
}

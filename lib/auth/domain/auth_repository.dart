import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../../core/domain/types.dart';

abstract interface class IAuthRepository {
  ResultFuture<PingResponse> pingServer({required PingRequest request});

  ResultFuture<LoginResponse> loginUser({required LoginRequest request});

  ResultFuture<RegisterResponse> registerUser(
      {required RegisterRequest request});

  ResultFuture<bool> isAuthenticated();
}

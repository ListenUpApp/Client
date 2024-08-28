import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';

import '../../../core/domain/types.dart';
import '../../../core/domain/usecases.dart';
import '../auth_repository.dart';

class LoginUsecase implements UsecaseWithParams<void, LoginRequest> {
  final IAuthRepository _repository;
  LoginUsecase(this._repository);

  @override
  ResultFuture<void> call(LoginRequest params) =>
      _repository.loginUser(request: params);
}

import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';

import '../../../core/domain/types.dart';
import '../../../core/domain/usecases.dart';
import '../auth_repository.dart';

class RegisterUsecase implements UsecaseWithParams<void, RegisterRequest> {
  final IAuthRepository _repository;
  RegisterUsecase(this._repository);

  @override
  ResultFuture<void> call(RegisterRequest params) =>
      _repository.registerUser(request: params);
}

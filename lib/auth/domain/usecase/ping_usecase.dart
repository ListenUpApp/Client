import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../../../core/domain/types.dart';
import '../../../core/domain/usecases.dart';
import '../auth_repository.dart';

class PingUsecase implements UsecaseWithParams<void, PingRequest> {
  final IAuthRepository _repository;
  PingUsecase(this._repository);

  @override
  ResultFuture<PingResponse> call(PingRequest params) =>
      _repository.pingServer(request: params);
}

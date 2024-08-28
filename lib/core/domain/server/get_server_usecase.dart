import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../types.dart';
import '../usecases.dart';
import 'server_repository.dart';

class GetServerUsecase implements UsecaseWithParams<void, GetServerRequest> {
  final IServerRepository _repository;
  GetServerUsecase(this._repository);

  @override
  ResultFuture<GetServerResponse> call(GetServerRequest params) =>
      _repository.getServer(request: params);
}

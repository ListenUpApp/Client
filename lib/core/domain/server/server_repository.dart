import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../types.dart';

abstract interface class IServerRepository {
  ResultFuture<GetServerResponse> getServer(
      {required GetServerRequest request});
}

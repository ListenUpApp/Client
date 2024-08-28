import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

abstract interface class IServerRemoteDataSource {
  Future<GetServerResponse> getServer(GetServerRequest request);
}

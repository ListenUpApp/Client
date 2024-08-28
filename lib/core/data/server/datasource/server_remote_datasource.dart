import 'package:listenup/core/domain/server/datasource/server_remote_datasource.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';

import '../../../domain/network/client_factory.dart';

class ServerRemoteDatasource implements IServerRemoteDataSource {
  final IGrpcClientFactory _clientFactory;

  ServerRemoteDatasource(this._clientFactory);

  @override
  Future<GetServerResponse> getServer(GetServerRequest request) async {
    final client = _clientFactory.getServerServiceClient();
    final response = await client.getServer(request);
    return response;
  }
}

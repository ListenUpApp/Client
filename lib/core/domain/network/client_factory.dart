import 'package:grpc/grpc.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pbgrpc.dart';
import 'package:listenup/generated/listenup/library/v1/library.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';

import '../../../generated/listenup/user/v1/user.pbgrpc.dart';

abstract interface class IGrpcClientFactory {
  ClientChannel getChannel();

  UserServiceClient getUserServiceClient();

  AuthServiceClient getAuthServiceClient();

  ServerServiceClient getServerServiceClient();

  LibraryServiceClient getLibraryServiceClient();

  FolderServiceClient getFolderServiceClient();

  Future<void> closeChannel();
}

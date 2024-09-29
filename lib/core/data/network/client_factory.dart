import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/auth/data/auth_interceptor.dart';
import 'package:listenup/auth/data/datasource/auth_local_datasource.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pbgrpc.dart';
import 'package:listenup/generated/listenup/library/v1/library.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:listenup/generated/listenup/user/v1/user.pbgrpc.dart';

import '../../../injection.dart';
import '../../domain/network/client_factory.dart';
import '../config/config_service.dart';

class GrpcClientFactory implements IGrpcClientFactory {
  final ConfigService _configService;

  GrpcClientFactory(this._configService);

  ClientChannel? _channel;

  @override
  Future<void> closeChannel() async {
    if (_channel != null) {
      await _channel!.shutdown();
      _channel = null;
    }
  }

  @override
  AuthServiceClient getAuthServiceClient() {
    return AuthServiceClient(getChannel());
  }

  @override
  ServerServiceClient getServerServiceClient() {
    return ServerServiceClient(getChannel());
  }

  @override
  LibraryServiceClient getLibraryServiceClient() {
    return LibraryServiceClient(getChannel(),
        interceptors: [AuthInterceptor(sl<AuthLocalDatasource>())]);
  }

  @override
  FolderServiceClient getFolderServiceClient() {
    return FolderServiceClient(getChannel(),
        interceptors: [AuthInterceptor(sl<AuthLocalDatasource>())]);
  }

  bool isProduction() {
    return Platform.environment['IS_PRODUCTION'] == '1';
  }

  @override
  ClientChannel getChannel() {
    if (_channel == null || _configService.grpcServerUrl != _channel!.host) {
      if (_channel != null) {
        _channel!.shutdown();
      }
      _channel = createChannel(
        _configService.grpcServerUrl!,
        50051,
        ChannelOptions(
          credentials: isProduction()
              ? const ChannelCredentials.secure()
              : const ChannelCredentials.insecure(),
        ),
      );
    }
    return _channel!;
  }

  @override
  UserServiceClient getUserServiceClient() {
    return UserServiceClient(getChannel());
  }

  @protected
  ClientChannel createChannel(String host, int port, ChannelOptions options) {
    return ClientChannel(
      host,
      port: port,
      options: options,
    );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:listenup/generated/listenup/user/v1/user.pbgrpc.dart';

import '../../domain/network/client_factory.dart';
import '../config/config_service.dart';

class GrpcClientFactory implements IGrpcClientFactory {
  final ConfigServiceImplementation _configService;

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
  ClientChannel getChannel() {
    if (_channel == null || _configService.grpcServerUrl != _channel!.host) {
      if (_channel != null) {
        _channel!.shutdown();
      }
      _channel = createChannel(
        _configService.grpcServerUrl!,
        50051,
        ChannelOptions(
          credentials: Platform.environment['IS_PRODUCTION'] == '1'
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

  // Make this method protected so it can be overridden in tests
  @protected
  ClientChannel createChannel(String host, int port, ChannelOptions options) {
    return ClientChannel(
      host,
      port: port,
      options: options,
    );
  }
}

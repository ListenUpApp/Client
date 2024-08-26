import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/data/network/client_factory.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:listenup/generated/listenup/user/v1/user.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigServiceImplementation extends Mock
    implements ConfigServiceImplementation {}

class MockClientChannel extends Mock implements ClientChannel {
  final String _host;
  MockClientChannel(this._host);

  @override
  String get host => _host;

  @override
  Future<void> shutdown() async {}
}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class MockServerServiceClient extends Mock implements ServerServiceClient {}

class MockUserServiceClient extends Mock implements UserServiceClient {}

class TestGrpcClientFactory extends GrpcClientFactory {
  TestGrpcClientFactory(super.configService);

  MockClientChannel? mockChannel;
  bool channelClosed = false;

  @override
  ClientChannel createChannel(String host, int port, ChannelOptions options) {
    mockChannel = MockClientChannel(host);
    return mockChannel!;
  }

  @override
  Future<void> closeChannel() async {
    await super.closeChannel();
    channelClosed = true;
  }
}

void main() {
  group('GrpcClientFactory', () {
    late TestGrpcClientFactory clientFactory;
    late MockConfigServiceImplementation mockConfigService;

    setUp(() {
      mockConfigService = MockConfigServiceImplementation();
      when(() => mockConfigService.grpcServerUrl)
          .thenReturn('test.example.com');
      clientFactory = TestGrpcClientFactory(mockConfigService);
    });

    test('getChannel creates a new channel when none exists', () {
      final channel = clientFactory.getChannel();
      expect(channel, isA<ClientChannel>());
      expect(clientFactory.mockChannel, isNotNull);
    });

    test('getChannel reuses existing channel when server URL hasn\'t changed',
        () {
      final channel1 = clientFactory.getChannel();
      final channel2 = clientFactory.getChannel();
      expect(identical(channel1, channel2), isTrue);
    });

    test('getChannel creates new channel when server URL changes', () {
      final channel1 = clientFactory.getChannel();
      when(() => mockConfigService.grpcServerUrl).thenReturn('new.example.com');
      final channel2 = clientFactory.getChannel();
      expect(identical(channel1, channel2), isFalse);
    });

    test('getAuthServiceClient returns AuthServiceClient', () {
      final client = clientFactory.getAuthServiceClient();
      expect(client, isA<AuthServiceClient>());
    });

    test('getServerServiceClient returns ServerServiceClient', () {
      final client = clientFactory.getServerServiceClient();
      expect(client, isA<ServerServiceClient>());
    });

    test('getUserServiceClient returns UserServiceClient', () {
      final client = clientFactory.getUserServiceClient();
      expect(client, isA<UserServiceClient>());
    });

    test('closeChannel closes the channel', () async {
      clientFactory.getChannel(); // Ensure a channel is created
      await clientFactory.closeChannel();
      expect(clientFactory.channelClosed, isTrue);
    });
  });
}

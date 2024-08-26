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
  @override
  final String host;
  MockClientChannel(this.host);

  @override
  Future<void> shutdown() async {}
}

class TestableGrpcClientFactory extends GrpcClientFactory {
  TestableGrpcClientFactory(super.configService);

  MockClientChannel? _mockChannel;

  @override
  ClientChannel createChannel(String host, int port, ChannelOptions options) {
    if (_mockChannel == null || _mockChannel!.host != host) {
      _mockChannel = MockClientChannel(host);
    }
    return _mockChannel!;
  }

  @override
  Future<void> closeChannel() async {
    await super.closeChannel();
    _mockChannel = null;
  }

  MockClientChannel? get currentChannel => _mockChannel;
}

void main() {
  late TestableGrpcClientFactory grpcClientFactory;
  late MockConfigServiceImplementation mockConfigService;

  setUp(() {
    mockConfigService = MockConfigServiceImplementation();
    grpcClientFactory = TestableGrpcClientFactory(mockConfigService);

    // Setup default behavior
    when(() => mockConfigService.grpcServerUrl).thenReturn('test.url');
  });

  group('GrpcClientFactory', () {
    test('getAuthServiceClient returns new instance each time', () {
      final client1 = grpcClientFactory.getAuthServiceClient();
      final client2 = grpcClientFactory.getAuthServiceClient();
      expect(client1, isA<AuthServiceClient>());
      expect(client2, isA<AuthServiceClient>());
      expect(client1, isNot(same(client2)));
    });

    test('getServerServiceClient returns new instance each time', () {
      final client1 = grpcClientFactory.getServerServiceClient();
      final client2 = grpcClientFactory.getServerServiceClient();
      expect(client1, isA<ServerServiceClient>());
      expect(client2, isA<ServerServiceClient>());
      expect(client1, isNot(same(client2)));
    });

    test('getUserServiceClient returns new instance each time', () {
      final client1 = grpcClientFactory.getUserServiceClient();
      final client2 = grpcClientFactory.getUserServiceClient();
      expect(client1, isA<UserServiceClient>());
      expect(client2, isA<UserServiceClient>());
      expect(client1, isNot(same(client2)));
    });

    group('getChannel', () {
      test('returns same channel for same URL', () {
        final channel1 = grpcClientFactory.getChannel();
        final channel2 = grpcClientFactory.getChannel();
        expect(channel1, same(channel2));
      });

      test('creates new channel when URL changes', () {
        final channel1 = grpcClientFactory.getChannel();

        when(() => mockConfigService.grpcServerUrl).thenReturn('new.test.url');
        final channel2 = grpcClientFactory.getChannel();

        expect(channel2, isNot(same(channel1)));
      });
    });

    group('closeChannel', () {
      test('does nothing if no channel exists', () async {
        await grpcClientFactory.closeChannel();
        expect(grpcClientFactory.currentChannel, isNull);
      });

      test('sets internal channel to null after closing', () async {
        grpcClientFactory.getChannel(); // Ensure a channel is created
        await grpcClientFactory.closeChannel();
        expect(grpcClientFactory.currentChannel, isNull);
      });
    });

    test('throws error when creating channel with null URL', () {
      when(() => mockConfigService.grpcServerUrl).thenReturn(null);
      expect(() => grpcClientFactory.getChannel(), throwsA(isA<TypeError>()));
    });
  });
}

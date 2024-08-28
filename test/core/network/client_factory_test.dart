import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/data/network/client_factory.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:listenup/generated/listenup/user/v1/user.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

class MockClientChannel extends Mock implements ClientChannel {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class MockServerServiceClient extends Mock implements ServerServiceClient {}

class MockUserServiceClient extends Mock implements UserServiceClient {}

class TestableGrpcClientFactory extends GrpcClientFactory {
  TestableGrpcClientFactory(super.configService);

  ChannelOptions? lastUsedOptions;
  bool _isProduction = false;

  @override
  bool isProduction() => _isProduction;

  void setProductionMode(bool isProduction) {
    _isProduction = isProduction;
  }

  @override
  ClientChannel createChannel(String host, int port, ChannelOptions options) {
    lastUsedOptions = options;
    return MockClientChannel();
  }
}

void main() {
  late TestableGrpcClientFactory factory;
  late MockConfigService mockConfigService;
  late MockClientChannel mockChannel;

  setUp(() {
    mockConfigService = MockConfigService();
    factory = TestableGrpcClientFactory(mockConfigService);
    mockChannel = MockClientChannel();

    // Set up default behavior
    when(() => mockConfigService.grpcServerUrl).thenReturn('test.example.com');
    when(() => mockChannel.shutdown()).thenAnswer((_) async {});
    when(() => mockChannel.host).thenReturn('test.example.com');
  });

  group('GrpcClientFactory', () {
    // ... other tests remain the same ...

    test('createChannel uses secure credentials in production', () {
      factory.setProductionMode(true);

      // Call getChannel to trigger channel creation
      factory.getChannel();

      // Verify that secure credentials were used
      expect(factory.lastUsedOptions?.credentials, isA<ChannelCredentials>());
      expect(factory.lastUsedOptions?.credentials,
          isNot(equals(const ChannelCredentials.insecure())));
    });

    test('createChannel uses insecure credentials in non-production', () {
      factory.setProductionMode(false);

      // Call getChannel to trigger channel creation
      factory.getChannel();

      // Verify that insecure credentials were used
      expect(factory.lastUsedOptions?.credentials,
          equals(const ChannelCredentials.insecure()));
    });
  });
}

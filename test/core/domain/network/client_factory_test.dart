import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/domain/network/client_factory.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:listenup/generated/listenup/user/v1/user.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';

class MockUserServiceClient extends Mock implements UserServiceClient {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class MockServerServiceClient extends Mock implements ServerServiceClient {}

class MockClientChannel extends Mock implements ClientChannel {}

// Create a mock class for IGrpcClientFactory
class MockGrpcClientFactory extends Mock implements IGrpcClientFactory {}

void main() {
  late MockGrpcClientFactory mockGrpcClientFactory;
  late MockClientChannel mockClientChannel;
  late MockUserServiceClient mockUserServiceClient;
  late MockAuthServiceClient mockAuthServiceClient;
  late MockServerServiceClient mockServerServiceClient;

  setUp(() {
    mockGrpcClientFactory = MockGrpcClientFactory();
    mockClientChannel = MockClientChannel();
    mockUserServiceClient = MockUserServiceClient();
    mockAuthServiceClient = MockAuthServiceClient();
    mockServerServiceClient = MockServerServiceClient();
  });

  group('IGrpcClientFactory Tests', () {
    test('getChannel returns a ClientChannel', () {
      // Arrange
      when(() => mockGrpcClientFactory.getChannel())
          .thenReturn(mockClientChannel);

      // Act
      final result = mockGrpcClientFactory.getChannel();

      // Assert
      expect(result, isA<ClientChannel>());
      verify(() => mockGrpcClientFactory.getChannel()).called(1);
    });

    test('getUserServiceClient returns a UserServiceClient', () {
      // Arrange
      when(() => mockGrpcClientFactory.getUserServiceClient())
          .thenReturn(mockUserServiceClient);

      // Act
      final result = mockGrpcClientFactory.getUserServiceClient();

      // Assert
      expect(result, isA<UserServiceClient>());
      verify(() => mockGrpcClientFactory.getUserServiceClient()).called(1);
    });

    test('getAuthServiceClient returns an AuthServiceClient', () {
      // Arrange
      when(() => mockGrpcClientFactory.getAuthServiceClient())
          .thenReturn(mockAuthServiceClient);

      // Act
      final result = mockGrpcClientFactory.getAuthServiceClient();

      // Assert
      expect(result, isA<AuthServiceClient>());
      verify(() => mockGrpcClientFactory.getAuthServiceClient()).called(1);
    });

    test('getServerServiceClient returns a ServerServiceClient', () {
      // Arrange
      when(() => mockGrpcClientFactory.getServerServiceClient())
          .thenReturn(mockServerServiceClient);

      // Act
      final result = mockGrpcClientFactory.getServerServiceClient();

      // Assert
      expect(result, isA<ServerServiceClient>());
      verify(() => mockGrpcClientFactory.getServerServiceClient()).called(1);
    });

    test('closeChannel closes the channel', () async {
      // Arrange
      when(() => mockGrpcClientFactory.closeChannel()).thenAnswer((_) async {});

      // Act
      await mockGrpcClientFactory.closeChannel();

      // Assert
      verify(() => mockGrpcClientFactory.closeChannel()).called(1);
    });
  });
}

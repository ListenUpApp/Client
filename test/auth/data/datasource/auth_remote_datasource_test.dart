import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/auth/data/datasource/auth_remote_datasource.dart';
import 'package:listenup/core/domain/network/client_factory.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';

class MockGrpcClientFactory extends Mock implements IGrpcClientFactory {}

class MockAuthServiceClient extends Mock implements AuthServiceClient {}

class MockServerServiceClient extends Mock implements ServerServiceClient {}

class FakeLoginRequest extends Fake implements LoginRequest {}

class FakeRegisterRequest extends Fake implements RegisterRequest {}

class FakePingRequest extends Fake implements PingRequest {}

// Custom ResponseFuture mock
class MockResponseFuture<T> extends Fake implements ResponseFuture<T> {
  final T _value;

  MockResponseFuture(this._value);

  @override
  Future<S> then<S>(FutureOr<S> Function(T value) onValue,
      {Function? onError}) async {
    return onValue(_value);
  }
}

void main() {
  late AuthRemoteDatasource authRemoteDatasource;
  late MockGrpcClientFactory mockClientFactory;
  late MockAuthServiceClient mockAuthServiceClient;
  late MockServerServiceClient mockServerServiceClient;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
    registerFallbackValue(FakeRegisterRequest());
    registerFallbackValue(FakePingRequest());
  });

  setUp(() {
    mockClientFactory = MockGrpcClientFactory();
    mockAuthServiceClient = MockAuthServiceClient();
    mockServerServiceClient = MockServerServiceClient();
    authRemoteDatasource = AuthRemoteDatasource(mockClientFactory);

    when(() => mockClientFactory.getAuthServiceClient())
        .thenReturn(mockAuthServiceClient);
    when(() => mockClientFactory.getServerServiceClient())
        .thenReturn(mockServerServiceClient);
  });

  group('AuthRemoteDatasource', () {
    group('loginUser', () {
      test('should return LoginResponse when login is successful', () async {
        // Arrange
        final loginRequest = LoginRequest();
        final loginResponse = LoginResponse();
        when(() => mockAuthServiceClient.login(any()))
            .thenAnswer((_) => MockResponseFuture(loginResponse));

        // Act
        final result = await authRemoteDatasource.loginUser(loginRequest);

        // Assert
        expect(result, equals(loginResponse));
        verify(() => mockClientFactory.getAuthServiceClient()).called(1);
        verify(() => mockAuthServiceClient.login(loginRequest)).called(1);
      });
    });

    group('pingServer', () {
      test('should return PingResponse when ping is successful', () async {
        // Arrange
        final pingResponse = PingResponse();
        when(() => mockServerServiceClient.ping(any()))
            .thenAnswer((_) => MockResponseFuture(pingResponse));

        // Act
        final result = await authRemoteDatasource.pingServer();

        // Assert
        expect(result, equals(pingResponse));
        verify(() => mockClientFactory.getServerServiceClient()).called(1);
        verify(() => mockServerServiceClient.ping(any())).called(1);
      });
    });

    group('registerUser', () {
      test('should return RegisterResponse when registration is successful',
          () async {
        // Arrange
        final registerRequest = RegisterRequest();
        final registerResponse = RegisterResponse();
        when(() => mockAuthServiceClient.register(any()))
            .thenAnswer((_) => MockResponseFuture(registerResponse));

        // Act
        final result = await authRemoteDatasource.registerUser(registerRequest);

        // Assert
        expect(result, equals(registerResponse));
        verify(() => mockClientFactory.getAuthServiceClient()).called(1);
        verify(() => mockAuthServiceClient.register(registerRequest)).called(1);
      });
    });
  });
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/data/server/datasource/server_remote_datasource.dart';
import 'package:listenup/core/domain/network/client_factory.dart';
import 'package:listenup/generated/listenup/server/v1/server.pbgrpc.dart';
import 'package:mocktail/mocktail.dart';

class MockGrpcClientFactory extends Mock implements IGrpcClientFactory {}

class MockServerServiceClient extends Mock implements ServerServiceClient {}

class FakeGetServerRequest extends Fake implements GetServerRequest {}

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
  late ServerRemoteDatasource serverRemoteDatasource;
  late MockGrpcClientFactory mockClientFactory;
  late MockServerServiceClient mockServerServiceClient;

  setUpAll(() {
    registerFallbackValue(FakeGetServerRequest());
  });

  setUp(() {
    mockClientFactory = MockGrpcClientFactory();
    mockServerServiceClient = MockServerServiceClient();
    serverRemoteDatasource = ServerRemoteDatasource(mockClientFactory);

    when(() => mockClientFactory.getServerServiceClient())
        .thenReturn(mockServerServiceClient);
  });

  group('ServerRemoteDatasource', () {
    group('getServer', () {
      test('should return GetServerResponse when the call is successful',
          () async {
        // Arrange
        final getServerRequest = GetServerRequest();
        final getServerResponse = GetServerResponse();
        when(() => mockServerServiceClient.getServer(any()))
            .thenAnswer((_) => MockResponseFuture(getServerResponse));

        // Act
        final result = await serverRemoteDatasource.getServer(getServerRequest);

        // Assert
        expect(result, equals(getServerResponse));
        verify(() => mockClientFactory.getServerServiceClient()).called(1);
        verify(() => mockServerServiceClient.getServer(getServerRequest))
            .called(1);
      });

      test('should throw GrpcError when the call fails', () async {
        // Arrange
        final getServerRequest = GetServerRequest();
        final grpcError = GrpcError.internal('Internal error');
        when(() => mockServerServiceClient.getServer(any()))
            .thenThrow(grpcError);

        // Act & Assert
        expect(
          () => serverRemoteDatasource.getServer(getServerRequest),
          throwsA(equals(grpcError)),
        );
        verify(() => mockClientFactory.getServerServiceClient()).called(1);
        verify(() => mockServerServiceClient.getServer(getServerRequest))
            .called(1);
      });
    });
  });
}

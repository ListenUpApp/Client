import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/data/server/server_repository.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/core/domain/server/datasource/server_remote_datasource.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart'
    as ServerV1;
import 'package:mocktail/mocktail.dart';

class MockServerRemoteDataSource extends Mock
    implements IServerRemoteDataSource {}

void main() {
  late ServerRepository repository;
  late MockServerRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockServerRemoteDataSource();
    repository = ServerRepository(mockRemoteDataSource);
  });

  group('getServer', () {
    final serverResponse = ServerV1.Server(
      isSetUp: true,
      config: ServerV1.ServerConfig(serverName: 'Test Server'),
    );
    final testRequest = ServerV1.GetServerRequest();
    final testResponse = ServerV1.GetServerResponse(server: serverResponse);

    test(
        'should return Right with GetServerResponse when the call is successful',
        () async {
      // Arrange
      when(() => mockRemoteDataSource.getServer(testRequest))
          .thenAnswer((_) async => testResponse);

      // Act
      final result = await repository.getServer(request: testRequest);

      // Assert
      expect(result, Right(testResponse));
      verify(() => mockRemoteDataSource.getServer(testRequest)).called(1);
    });

    test('should return Left with GrpcFailure when a GrpcError occurs',
        () async {
      // Arrange
      const grpcError = GrpcError.deadlineExceeded('Deadline exceeded');
      when(() => mockRemoteDataSource.getServer(testRequest))
          .thenThrow(grpcError);

      // Act
      final result = await repository.getServer(request: testRequest);

      // Assert
      expect(
        result,
        Left(GrpcFailure(
            code: grpcError.code,
            message: grpcError.message ?? 'Unknown gRPC error')),
      );
      verify(() => mockRemoteDataSource.getServer(testRequest)).called(1);
    });

    test(
        'should return Left with UnexpectedFailure when an unexpected error occurs',
        () async {
      // Arrange
      final unexpectedError = Exception('Unexpected error');
      when(() => mockRemoteDataSource.getServer(testRequest))
          .thenThrow(unexpectedError);

      // Act
      final result = await repository.getServer(request: testRequest);

      // Assert
      expect(
        result,
        Left(UnexpectedFailure(unexpectedError.toString())),
      );
      verify(() => mockRemoteDataSource.getServer(testRequest)).called(1);
    });
  });
}

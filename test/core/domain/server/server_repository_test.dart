import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/core/domain/server/get_server_usecase.dart';
import 'package:listenup/core/domain/server/server_repository.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockServerRepository extends Mock implements IServerRepository {}

void main() {
  late GetServerUsecase getServerUsecase;
  late MockServerRepository mockRepository;

  setUp(() {
    mockRepository = MockServerRepository();
    getServerUsecase = GetServerUsecase(mockRepository);
  });

  group('GetServerUsecase', () {
    final tRequest = GetServerRequest();
    final tResponse = GetServerResponse(
      server: Server(
        isSetUp: true,
        config: ServerConfig(serverName: 'Test Server'),
      ),
    );

    test('should get server from the repository', () async {
      // Arrange
      when(() => mockRepository.getServer(request: tRequest))
          .thenAnswer((_) async => Right(tResponse));

      // Act
      final result = await getServerUsecase(tRequest);

      // Assert
      expect(result, Right(tResponse));
      verify(() => mockRepository.getServer(request: tRequest)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository call fails', () async {
      // Arrange
      final failure = GrpcFailure(code: 0, message: "message");
      when(() => mockRepository.getServer(request: tRequest))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await getServerUsecase(tRequest);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.getServer(request: tRequest)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('IServerRepository', () {
    final tRequest = GetServerRequest();
    final tResponse = GetServerResponse(
      server: Server(
        isSetUp: true,
        config: ServerConfig(serverName: 'Test Server'),
      ),
    );

    test('getServer should return GetServerResponse on success', () async {
      // Arrange
      when(() => mockRepository.getServer(request: tRequest))
          .thenAnswer((_) async => Right(tResponse));

      // Act
      final result = await mockRepository.getServer(request: tRequest);

      // Assert
      expect(result, Right(tResponse));
      verify(() => mockRepository.getServer(request: tRequest)).called(1);
    });

    test('getServer should return Failure on error', () async {
      // Arrange
      final failure = GrpcFailure(code: 0, message: "message");
      when(() => mockRepository.getServer(request: tRequest))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await mockRepository.getServer(request: tRequest);

      // Assert
      expect(result, Left(failure));
      verify(() => mockRepository.getServer(request: tRequest)).called(1);
    });
  });
}

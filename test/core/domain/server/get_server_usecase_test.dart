import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/core/domain/server/get_server_usecase.dart';
import 'package:listenup/core/domain/server/server_repository.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockServerRepository extends Mock implements IServerRepository {}

void main() {
  late GetServerUsecase usecase;
  late MockServerRepository mockRepository;

  setUp(() {
    mockRepository = MockServerRepository();
    usecase = GetServerUsecase(mockRepository);
  });

  group('GetServerUsecase Tests', () {
    test('should return GetServerResponse when repository call is successful',
        () async {
      // Arrange
      final request = GetServerRequest();
      final response = GetServerResponse()
        ..server = (Server()
          ..isSetUp = true
          ..config = (ServerConfig()..serverName = 'Test Server'));

      when(() => mockRepository.getServer(request: request))
          .thenAnswer((_) async => Right(response));

      // Act
      final result = await usecase(request);

      // Assert
      expect(result, isA<Right<Failure, GetServerResponse>>());
      result.fold(
        (failure) => fail('Should not return a failure'),
        (response) {
          expect(response.server.isSetUp, isTrue);
          expect(response.server.config.serverName, equals('Test Server'));
        },
      );
      verify(() => mockRepository.getServer(request: request)).called(1);
    });

    test('should return Failure when repository call is unsuccessful',
        () async {
      // Arrange
      final request = GetServerRequest();
      final failure =
          GrpcFailure(code: 0, message: 'Error fetching server data');

      when(() => mockRepository.getServer(request: request))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await usecase(request);

      // Assert
      expect(result, isA<Left<Failure, GetServerResponse>>());
      result.fold(
        (responseFailure) =>
            expect(failure.message, equals('Error fetching server data')),
        (_) => fail('Should not return a success'),
      );
      verify(() => mockRepository.getServer(request: request)).called(1);
    });
  });
}

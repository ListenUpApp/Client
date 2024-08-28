import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/ping_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakePingRequest extends Fake implements PingRequest {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late PingUsecase pingUsecase;

  setUpAll(() {
    registerFallbackValue(FakePingRequest());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    pingUsecase = PingUsecase(mockAuthRepository);
  });

  group('PingUsecase', () {
    test('should return PingResponse when repository call is successful',
        () async {
      // Arrange
      final pingRequest = PingRequest();
      final pingResponse = PingResponse()..message = 'Pong';
      when(() => mockAuthRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Right(pingResponse));

      // Act
      final result = await pingUsecase(pingRequest);

      // Assert
      expect(result, Right(pingResponse));
      verify(() => mockAuthRepository.pingServer(request: pingRequest))
          .called(1);
    });

    test('should return failure when repository call is unsuccessful',
        () async {
      // Arrange
      final pingRequest = PingRequest();
      final failure = GrpcFailure(code: 0, message: "message");
      when(() => mockAuthRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await pingUsecase(pingRequest);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.pingServer(request: pingRequest))
          .called(1);
    });
  });
}

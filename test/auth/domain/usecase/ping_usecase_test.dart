import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/ping_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late PingUsecase pingUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    pingUsecase = PingUsecase(mockAuthRepository);
  });

  test(
      'should return Right(PingResponse) when call to repository is successful',
      () async {
    // Arrange
    final pingRequest = PingRequest();
    final pingResponse = PingResponse();
    when(() => mockAuthRepository.pingServer(request: pingRequest))
        .thenAnswer((_) async => Right(pingResponse));

    // Act
    final result = await pingUsecase(pingRequest);

    // Assert
    expect(result, Right(pingResponse));
    verify(() => mockAuthRepository.pingServer(request: pingRequest)).called(1);
  });

  test(
      'should return Left(GrpcFailure) when call to repository fails with GrpcException',
      () async {
    // Arrange
    final pingRequest = PingRequest();
    final failure = GrpcFailure(code: 13, message: 'INTERNAL');
    when(() => mockAuthRepository.pingServer(request: pingRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await pingUsecase(pingRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.pingServer(request: pingRequest)).called(1);
  });

  test(
      'should return Left(UnexpectedFailure) when call to repository fails unexpectedly',
      () async {
    // Arrange
    final pingRequest = PingRequest();
    final failure = UnexpectedFailure('Unexpected error during ping');
    when(() => mockAuthRepository.pingServer(request: pingRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await pingUsecase(pingRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.pingServer(request: pingRequest)).called(1);
  });
}

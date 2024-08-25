import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/login_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(mockAuthRepository);
  });

  test(
      'should return Right(LoginResponse) when call to repository is successful',
      () async {
    // Arrange
    final loginRequest = LoginRequest();
    final loginResponse = LoginResponse();
    when(() => mockAuthRepository.loginUser(request: loginRequest))
        .thenAnswer((_) async => Right(loginResponse));

    // Act
    final result = await loginUsecase(loginRequest);

    // Assert
    expect(result, Right(loginResponse));
    verify(() => mockAuthRepository.loginUser(request: loginRequest)).called(1);
  });

  test(
      'should return Left(GrpcFailure) when call to repository fails with GrpcException',
      () async {
    // Arrange
    final loginRequest = LoginRequest();
    final failure = GrpcFailure(code: 16, message: 'UNAUTHENTICATED');
    when(() => mockAuthRepository.loginUser(request: loginRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await loginUsecase(loginRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.loginUser(request: loginRequest)).called(1);
  });

  test(
      'should return Left(UnexpectedFailure) when call to repository fails unexpectedly',
      () async {
    // Arrange
    final loginRequest = LoginRequest();
    final failure = UnexpectedFailure('Unexpected error during login');
    when(() => mockAuthRepository.loginUser(request: loginRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await loginUsecase(loginRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.loginUser(request: loginRequest)).called(1);
  });
}

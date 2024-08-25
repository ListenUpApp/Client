import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/register_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase registerUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(mockAuthRepository);
  });

  test(
      'should return Right(RegisterResponse) when call to repository is successful',
      () async {
    // Arrange
    final registerRequest = RegisterRequest();
    final registerResponse = RegisterResponse();
    when(() => mockAuthRepository.registerUser(request: registerRequest))
        .thenAnswer((_) async => Right(registerResponse));

    // Act
    final result = await registerUsecase(registerRequest);

    // Assert
    expect(result, Right(registerResponse));
    verify(() => mockAuthRepository.registerUser(request: registerRequest))
        .called(1);
  });

  test(
      'should return Left(GrpcFailure) when call to repository fails with GrpcException',
      () async {
    // Arrange
    final registerRequest = RegisterRequest();
    final failure = GrpcFailure(code: 6, message: 'ALREADY_EXISTS');
    when(() => mockAuthRepository.registerUser(request: registerRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await registerUsecase(registerRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.registerUser(request: registerRequest))
        .called(1);
  });

  test(
      'should return Left(UnexpectedFailure) when call to repository fails unexpectedly',
      () async {
    // Arrange
    final registerRequest = RegisterRequest();
    final failure = UnexpectedFailure('Unexpected error during registration');
    when(() => mockAuthRepository.registerUser(request: registerRequest))
        .thenAnswer((_) async => Left(failure));

    // Act
    final result = await registerUsecase(registerRequest);

    // Assert
    expect(result, Left(failure));
    verify(() => mockAuthRepository.registerUser(request: registerRequest))
        .called(1);
  });
}

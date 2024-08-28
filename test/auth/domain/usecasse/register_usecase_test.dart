import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/register_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeRegisterRequest extends Fake implements RegisterRequest {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late RegisterUsecase registerUsecase;

  setUpAll(() {
    registerFallbackValue(FakeRegisterRequest());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(mockAuthRepository);
  });

  group('RegisterUsecase', () {
    test('should register user when repository call is successful', () async {
      // Arrange
      final registerRequest = RegisterRequest()
        ..name = 'John Doe'
        ..email = 'john@example.com'
        ..password = 'password123';
      final registerResponse = RegisterResponse();
      when(() =>
              mockAuthRepository.registerUser(request: any(named: 'request')))
          .thenAnswer((_) async => Right(registerResponse));

      // Act
      final result = await registerUsecase(registerRequest);

      // Assert
      expect(result, Right(registerResponse));
      verify(() => mockAuthRepository.registerUser(request: registerRequest))
          .called(1);
    });

    test('should return failure when repository call is unsuccessful',
        () async {
      // Arrange
      final registerRequest = RegisterRequest()
        ..name = 'John Doe'
        ..email = 'john@example.com'
        ..password = 'password123';
      final failure = GrpcFailure(code: 0, message: "error");
      when(() =>
              mockAuthRepository.registerUser(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await registerUsecase(registerRequest);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.registerUser(request: registerRequest))
          .called(1);
    });
  });
}

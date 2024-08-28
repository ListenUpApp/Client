import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/auth/domain/usecase/login_usecase.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUsecase loginUsecase;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(mockAuthRepository);
  });

  group('LoginUsecase', () {
    test('should login user when repository call is successful', () async {
      // Arrange
      final loginRequest = LoginRequest()
        ..email = 'test@example.com'
        ..password = 'password123';
      final loginResponse = LoginResponse()..accessToken = 'test_token';
      when(() => mockAuthRepository.loginUser(request: any(named: 'request')))
          .thenAnswer((_) async => Right(loginResponse));

      // Act
      final result = await loginUsecase(loginRequest);

      // Assert
      expect(result, Right(loginResponse));
      verify(() => mockAuthRepository.loginUser(request: loginRequest))
          .called(1);
    });

    test('should return failure when repository call is unsuccessful',
        () async {
      // Arrange
      final loginRequest = LoginRequest()
        ..email = 'test@example.com'
        ..password = 'password123';
      final failure = GrpcFailure(code: 0, message: "messages");
      when(() => mockAuthRepository.loginUser(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await loginUsecase(loginRequest);

      // Assert
      expect(result, Left(failure));
      verify(() => mockAuthRepository.loginUser(request: loginRequest))
          .called(1);
    });
  });
}

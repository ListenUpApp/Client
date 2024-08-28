import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

// Fake classes for request types
class FakePingRequest extends Fake implements PingRequest {}

class FakeLoginRequest extends Fake implements LoginRequest {}

class FakeRegisterRequest extends Fake implements RegisterRequest {}

void main() {
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakePingRequest());
    registerFallbackValue(FakeLoginRequest());
    registerFallbackValue(FakeRegisterRequest());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('IAuthRepository Tests', () {
    test('pingServer should return PingResponse on success', () async {
      final request = PingRequest();
      final response = PingResponse()..message = 'Pong';
      when(() => mockRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Right(response));

      final result = await mockRepository.pingServer(request: request);

      expect(result, Right(response));
      verify(() => mockRepository.pingServer(request: any(named: 'request')))
          .called(1);
    });

    test('loginUser should return LoginResponse on success', () async {
      final request = LoginRequest()
        ..email = 'email@example.com'
        ..password = 'password123';
      final response = LoginResponse()..accessToken = 'test_token';
      when(() => mockRepository.loginUser(request: any(named: 'request')))
          .thenAnswer((_) async => Right(response));

      final result = await mockRepository.loginUser(request: request);

      expect(result, Right(response));
      verify(() => mockRepository.loginUser(request: any(named: 'request')))
          .called(1);
    });

    test('registerUser should return RegisterResponse on success', () async {
      final request = RegisterRequest()
        ..name = "john doe"
        ..email = 'email@example.com'
        ..password = 'newpassword123';
      final response = RegisterResponse();
      when(() => mockRepository.registerUser(request: any(named: 'request')))
          .thenAnswer((_) async => Right(response));

      final result = await mockRepository.registerUser(request: request);

      expect(result, Right(response));
      verify(() => mockRepository.registerUser(request: any(named: 'request')))
          .called(1);
    });

    test('isAuthenticated should return true when authenticated', () async {
      when(() => mockRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(true));

      final result = await mockRepository.isAuthenticated();

      expect(result, const Right(true));
      verify(() => mockRepository.isAuthenticated()).called(1);
    });

    test('isAuthenticated should return false when not authenticated',
        () async {
      when(() => mockRepository.isAuthenticated())
          .thenAnswer((_) async => const Right(false));

      final result = await mockRepository.isAuthenticated();

      expect(result, const Right(false));
      verify(() => mockRepository.isAuthenticated()).called(1);
    });

    test('All methods should return Failure on error', () async {
      final failure = GrpcFailure(code: 0, message: "Error Message");
      when(() => mockRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));
      when(() => mockRepository.loginUser(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));
      when(() => mockRepository.registerUser(request: any(named: 'request')))
          .thenAnswer((_) async => Left(failure));
      when(() => mockRepository.isAuthenticated())
          .thenAnswer((_) async => Left(failure));

      expect(await mockRepository.pingServer(request: PingRequest()),
          Left(failure));
      expect(await mockRepository.loginUser(request: LoginRequest()),
          Left(failure));
      expect(await mockRepository.registerUser(request: RegisterRequest()),
          Left(failure));
      expect(await mockRepository.isAuthenticated(), Left(failure));

      verify(() => mockRepository.pingServer(request: any(named: 'request')))
          .called(1);
      verify(() => mockRepository.loginUser(request: any(named: 'request')))
          .called(1);
      verify(() => mockRepository.registerUser(request: any(named: 'request')))
          .called(1);
      verify(() => mockRepository.isAuthenticated()).called(1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/domain/datasource/auth_remote_datasource.dart';
import 'package:listenup/auth/domain/token_storage.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockTokenStorage extends Mock implements ITokenStorage {}

void main() {
  late AuthRepository authRepository;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockTokenStorage = MockTokenStorage();
    authRepository = AuthRepository(mockAuthRemoteDataSource, mockTokenStorage);
  });

  group('AuthRepository', () {
    test('pingServer returns Right(PingResponse) on success', () async {
      final pingRequest = PingRequest();
      final pingResponse = PingResponse();
      when(() => mockAuthRemoteDataSource.pingServer())
          .thenAnswer((_) async => pingResponse);

      final result = await authRepository.pingServer(request: pingRequest);

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Expected Right, got Left'),
          (r) => expect(r, equals(pingResponse)));
    });

    test('pingServer returns Left(GrpcFailure) on GrpcError', () async {
      final pingRequest = PingRequest();
      when(() => mockAuthRemoteDataSource.pingServer())
          .thenThrow(const GrpcError.invalidArgument('Test error'));

      final result = await authRepository.pingServer(request: pingRequest);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<GrpcFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });

    test('loginUser returns Right(LoginResponse) and saves token on success',
        () async {
      final loginRequest = LoginRequest();
      final loginResponse = LoginResponse()..accessToken = 'test_token';
      when(() => mockAuthRemoteDataSource.loginUser(loginRequest))
          .thenAnswer((_) async => loginResponse);
      when(() => mockTokenStorage.saveToken(any())).thenAnswer((_) async {});

      final result = await authRepository.loginUser(request: loginRequest);

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Expected Right, got Left'),
          (r) => expect(r, equals(loginResponse)));
      verify(() => mockTokenStorage.saveToken('test_token')).called(1);
    });

    test('loginUser returns Left(GrpcFailure) on GrpcError', () async {
      final loginRequest = LoginRequest();
      when(() => mockAuthRemoteDataSource.loginUser(loginRequest))
          .thenThrow(const GrpcError.unauthenticated('Test error'));

      final result = await authRepository.loginUser(request: loginRequest);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<GrpcFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });

    test('registerUser returns Right(RegisterResponse) on success', () async {
      final registerRequest = RegisterRequest();
      final registerResponse = RegisterResponse();
      when(() => mockAuthRemoteDataSource.registerUser(registerRequest))
          .thenAnswer((_) async => registerResponse);

      final result =
          await authRepository.registerUser(request: registerRequest);

      expect(result.isRight(), isTrue);
      result.fold((l) => fail('Expected Right, got Left'),
          (r) => expect(r, equals(registerResponse)));
    });

    test('registerUser returns Left(GrpcFailure) on GrpcError', () async {
      final registerRequest = RegisterRequest();
      when(() => mockAuthRemoteDataSource.registerUser(registerRequest))
          .thenThrow(const GrpcError.alreadyExists('Test error'));

      final result =
          await authRepository.registerUser(request: registerRequest);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<GrpcFailure>()),
        (_) => fail('Expected Left, got Right'),
      );
    });
  });
}

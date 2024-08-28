import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/domain/datasource/auth_local_datasource.dart';
import 'package:listenup/auth/domain/datasource/auth_remote_datasource.dart';
import 'package:listenup/auth/domain/token_storage.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements IAuthLocalDataSource {}

class MockTokenStorage extends Mock implements ITokenStorage {}

class FakePingRequest extends Fake implements PingRequest {}

class FakeLoginRequest extends Fake implements LoginRequest {}

class FakeRegisterRequest extends Fake implements RegisterRequest {}

void main() {
  late AuthRepository authRepository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockTokenStorage mockTokenStorage;

  setUpAll(() {
    registerFallbackValue(FakePingRequest());
    registerFallbackValue(FakeLoginRequest());
    registerFallbackValue(FakeRegisterRequest());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    mockTokenStorage = MockTokenStorage();
    authRepository = AuthRepository(
      mockRemoteDataSource,
      mockTokenStorage,
      mockLocalDataSource,
    );
  });

  group('AuthRepository', () {
    group('pingServer', () {
      test('should return Right(PingResponse) when the call is successful',
          () async {
        // Arrange
        final pingResponse = PingResponse();
        when(() => mockRemoteDataSource.pingServer())
            .thenAnswer((_) async => pingResponse);

        // Act
        final result = await authRepository.pingServer(request: PingRequest());

        // Assert
        expect(result, Right(pingResponse));
        verify(() => mockRemoteDataSource.pingServer()).called(1);
      });

      test('should return Left(GrpcFailure) when a GrpcError occurs', () async {
        // Arrange
        final grpcError = GrpcError.internal('Test error');
        when(() => mockRemoteDataSource.pingServer()).thenThrow(grpcError);

        // Act
        final result = await authRepository.pingServer(request: PingRequest());

        // Assert
        expect(
            result,
            Left(GrpcFailure(
                code: grpcError.code, message: grpcError.message!)));
        verify(() => mockRemoteDataSource.pingServer()).called(1);
      });

      test(
          'should return Left(UnexpectedFailure) when an unexpected error occurs',
          () async {
        // Arrange
        when(() => mockRemoteDataSource.pingServer())
            .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await authRepository.pingServer(request: PingRequest());

        // Assert
        expect(result, Left(UnexpectedFailure('Exception: Unexpected error')));
        verify(() => mockRemoteDataSource.pingServer()).called(1);
      });
    });

    group('loginUser', () {
      test(
          'should return Right(LoginResponse) and save token when the call is successful',
          () async {
        // Arrange
        final loginRequest = LoginRequest();
        final loginResponse = LoginResponse()..accessToken = 'test_token';
        when(() => mockRemoteDataSource.loginUser(any()))
            .thenAnswer((_) async => loginResponse);
        when(() => mockTokenStorage.saveToken(any())).thenAnswer((_) async {});

        // Act
        final result = await authRepository.loginUser(request: loginRequest);

        // Assert
        expect(result, Right(loginResponse));
        verify(() => mockRemoteDataSource.loginUser(loginRequest)).called(1);
        verify(() => mockTokenStorage.saveToken('test_token')).called(1);
      });

      // Add similar tests for GrpcError and unexpected error cases
    });

    group('registerUser', () {
      test('should return Right(RegisterResponse) when the call is successful',
          () async {
        // Arrange
        final registerRequest = RegisterRequest();
        final registerResponse = RegisterResponse();
        when(() => mockRemoteDataSource.registerUser(any()))
            .thenAnswer((_) async => registerResponse);

        // Act
        final result =
            await authRepository.registerUser(request: registerRequest);

        // Assert
        expect(result, Right(registerResponse));
        verify(() => mockRemoteDataSource.registerUser(registerRequest))
            .called(1);
      });

      // Add similar tests for GrpcError and unexpected error cases
    });

    group('isAuthenticated', () {
      test('should return Right(true) when user is authenticated', () async {
        // Arrange
        when(() => mockLocalDataSource.isAuthenticated())
            .thenAnswer((_) async => true);

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, const Right(true));
        verify(() => mockLocalDataSource.isAuthenticated()).called(1);
      });

      test('should return Right(false) when user is not authenticated',
          () async {
        // Arrange
        when(() => mockLocalDataSource.isAuthenticated())
            .thenAnswer((_) async => false);

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, const Right(false));
        verify(() => mockLocalDataSource.isAuthenticated()).called(1);
      });

      test('should return Left(UnexpectedFailure) when an error occurs',
          () async {
        // Arrange
        when(() => mockLocalDataSource.isAuthenticated())
            .thenThrow(Exception('Test error'));

        // Act
        final result = await authRepository.isAuthenticated();

        // Assert
        expect(result, Left(UnexpectedFailure('Exception: Test error')));
        verify(() => mockLocalDataSource.isAuthenticated()).called(1);
      });
    });
  });
}

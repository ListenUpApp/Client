import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/domain/datasource/auth_remote_datasource.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
  });

  setUpAll(() {
    registerFallbackValue(LoginRequest());
    registerFallbackValue(RegisterRequest());
  });

  group('IAuthRemoteDataSource Tests', () {
    test('pingServer should return PingResponse', () async {
      // Arrange
      final response = PingResponse()..message = 'Pong';
      when(() => mockDataSource.pingServer()).thenAnswer((_) async => response);

      // Act
      final result = await mockDataSource.pingServer();

      // Assert
      expect(result, equals(response));
      expect(result.message, equals('Pong'));
      verify(() => mockDataSource.pingServer()).called(1);
    });

    test('loginUser should return LoginResponse', () async {
      // Arrange
      final request = LoginRequest()
        ..email = 'test@example.com'
        ..password = 'password123';
      final response = LoginResponse()..accessToken = 'test_access_token';
      when(() => mockDataSource.loginUser(any()))
          .thenAnswer((_) async => response);

      // Act
      final result = await mockDataSource.loginUser(request);

      // Assert
      expect(result, equals(response));
      expect(result.accessToken, equals('test_access_token'));
      verify(() => mockDataSource.loginUser(request)).called(1);
    });

    test('registerUser should return RegisterResponse', () async {
      // Arrange
      final request = RegisterRequest()
        ..name = 'John Doe'
        ..email = 'john@example.com'
        ..password = 'securepassword123';
      final response = RegisterResponse();
      when(() => mockDataSource.registerUser(any()))
          .thenAnswer((_) async => response);

      // Act
      final result = await mockDataSource.registerUser(request);

      // Assert
      expect(result, equals(response));
      verify(() => mockDataSource.registerUser(request)).called(1);
    });

    test('pingServer should throw exception on error', () async {
      // Arrange
      when(() => mockDataSource.pingServer())
          .thenThrow(Exception('Server error'));

      // Act & Assert
      expect(() => mockDataSource.pingServer(), throwsException);
      verify(() => mockDataSource.pingServer()).called(1);
    });

    test('loginUser should throw exception on error', () async {
      // Arrange
      final request = LoginRequest()
        ..email = 'test@example.com'
        ..password = 'password123';
      when(() => mockDataSource.loginUser(any()))
          .thenThrow(Exception('Login failed'));

      // Act & Assert
      expect(() => mockDataSource.loginUser(request), throwsException);
      verify(() => mockDataSource.loginUser(request)).called(1);
    });

    test('registerUser should throw exception on error', () async {
      // Arrange
      final request = RegisterRequest()
        ..name = 'John Doe'
        ..email = 'john@example.com'
        ..password = 'securepassword123';
      when(() => mockDataSource.registerUser(any()))
          .thenThrow(Exception('Registration failed'));

      // Act & Assert
      expect(() => mockDataSource.registerUser(request), throwsException);
      verify(() => mockDataSource.registerUser(request)).called(1);
    });
  });
}

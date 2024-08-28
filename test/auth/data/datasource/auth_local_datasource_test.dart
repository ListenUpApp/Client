import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/data/datasource/auth_local_datasource.dart';
import 'package:listenup/auth/data/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late AuthLocalDatasource authLocalDatasource;
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    authLocalDatasource = AuthLocalDatasource(mockTokenStorage);
  });

  group('AuthLocalDatasource', () {
    group('isAuthenticated', () {
      test('should return true when a non-empty token exists', () async {
        // Arrange
        when(() => mockTokenStorage.getToken())
            .thenAnswer((_) async => 'valid_token');

        // Act
        final result = await authLocalDatasource.isAuthenticated();

        // Assert
        expect(result, true);
        verify(() => mockTokenStorage.getToken()).called(1);
      });

      test('should return false when token is empty', () async {
        // Arrange
        when(() => mockTokenStorage.getToken()).thenAnswer((_) async => '');

        // Act
        final result = await authLocalDatasource.isAuthenticated();

        // Assert
        expect(result, false);
        verify(() => mockTokenStorage.getToken()).called(1);
      });

      test('should return false when token is null', () async {
        // Arrange
        when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);

        // Act
        final result = await authLocalDatasource.isAuthenticated();

        // Assert
        expect(result, false);
        verify(() => mockTokenStorage.getToken()).called(1);
      });
    });
  });
}

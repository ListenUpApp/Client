import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/domain/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements ITokenStorage {}

void main() {
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
  });

  group('ITokenStorage Tests', () {
    test('saveToken stores the token successfully', () async {
      // Arrange
      const token = 'test_token';
      when(() => mockTokenStorage.saveToken(token)).thenAnswer((_) async {});

      // Act
      await mockTokenStorage.saveToken(token);

      // Assert
      verify(() => mockTokenStorage.saveToken(token)).called(1);
    });

    test('getToken returns the stored token', () async {
      // Arrange
      const expectedToken = 'test_token';
      when(() => mockTokenStorage.getToken())
          .thenAnswer((_) async => expectedToken);

      // Act
      final result = await mockTokenStorage.getToken();

      // Assert
      expect(result, equals(expectedToken));
      verify(() => mockTokenStorage.getToken()).called(1);
    });

    test('getToken returns null when no token is stored', () async {
      // Arrange
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);

      // Act
      final result = await mockTokenStorage.getToken();

      // Assert
      expect(result, isNull);
      verify(() => mockTokenStorage.getToken()).called(1);
    });

    test('deleteToken removes the stored token', () async {
      // Arrange
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async {});

      // Act
      await mockTokenStorage.deleteToken();

      // Assert
      verify(() => mockTokenStorage.deleteToken()).called(1);
    });

    test('Full token lifecycle: save, get, and delete', () async {
      // Arrange
      const token = 'lifecycle_test_token';
      when(() => mockTokenStorage.saveToken(token)).thenAnswer((_) async {});
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => token);
      when(() => mockTokenStorage.deleteToken()).thenAnswer((_) async {});

      // Act & Assert
      // Save token
      await mockTokenStorage.saveToken(token);
      verify(() => mockTokenStorage.saveToken(token)).called(1);

      // Get token
      final retrievedToken = await mockTokenStorage.getToken();
      expect(retrievedToken, equals(token));
      verify(() => mockTokenStorage.getToken()).called(1);

      // Delete token
      await mockTokenStorage.deleteToken();
      verify(() => mockTokenStorage.deleteToken()).called(1);

      // Verify token is deleted
      when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
      final deletedToken = await mockTokenStorage.getToken();
      expect(deletedToken, isNull);
      verify(() => mockTokenStorage.getToken()).called(1);
    });
  });
}

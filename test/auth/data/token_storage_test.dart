import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/data/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TokenStorage tokenStorage;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(mockSecureStorage);
  });

  group('TokenStorage', () {
    const testToken = 'test_token';
    const storageKey = 'auth_token';

    test('saveToken should write token to secure storage', () async {
      // Arrange
      when(() => mockSecureStorage.write(key: storageKey, value: testToken))
          .thenAnswer((_) async {});

      // Act
      await tokenStorage.saveToken(testToken);

      // Assert
      verify(() => mockSecureStorage.write(key: storageKey, value: testToken))
          .called(1);
    });

    test('getToken should read token from secure storage', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: storageKey))
          .thenAnswer((_) async => testToken);

      // Act
      final result = await tokenStorage.getToken();

      // Assert
      expect(result, equals(testToken));
      verify(() => mockSecureStorage.read(key: storageKey)).called(1);
    });

    test('deleteToken should delete token from secure storage', () async {
      // Arrange
      when(() => mockSecureStorage.delete(key: storageKey))
          .thenAnswer((_) async {});

      // Act
      await tokenStorage.deleteToken();

      // Assert
      verify(() => mockSecureStorage.delete(key: storageKey)).called(1);
    });
  });
}

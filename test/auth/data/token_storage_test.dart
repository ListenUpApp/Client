import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/data/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late TokenStorageImplementation tokenStorage;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorageImplementation(mockSecureStorage);
  });

  group('TokenStorageImplementation', () {
    test('saveToken writes to secure storage', () async {
      const testToken = 'test_token';
      when(() => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) => Future.value());

      await tokenStorage.saveToken(testToken);

      verify(() => mockSecureStorage.write(key: 'auth_token', value: testToken))
          .called(1);
    });

    test('getToken reads from secure storage', () async {
      const testToken = 'test_token';
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) => Future.value(testToken));

      final result = await tokenStorage.getToken();

      expect(result, equals(testToken));
      verify(() => mockSecureStorage.read(key: 'auth_token')).called(1);
    });

    test('deleteToken deletes from secure storage', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) => Future.value());

      await tokenStorage.deleteToken();

      verify(() => mockSecureStorage.delete(key: 'auth_token')).called(1);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/domain/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements ITokenStorage {}

void main() {
  group('ITokenStorage Tests', () {
    late MockTokenStorage storage;

    setUp(() {
      storage = MockTokenStorage();
    });

    test('saveToken completes without error', () async {
      when(() => storage.saveToken(any())).thenAnswer((_) async {});

      await expectLater(storage.saveToken('test_token'), completes);
    });

    test('getToken returns a String when token exists', () async {
      when(() => storage.getToken()).thenAnswer((_) async => 'test_token');

      final token = await storage.getToken();
      expect(token, isA<String>());
    });

    test('getToken returns null when no token exists', () async {
      when(() => storage.getToken()).thenAnswer((_) async => null);

      final token = await storage.getToken();
      expect(token, isNull);
    });

    test('deleteToken completes without error', () async {
      when(() => storage.deleteToken()).thenAnswer((_) async {});

      await expectLater(storage.deleteToken(), completes);
    });

    test('getToken returns null after deleteToken', () async {
      // Set up the mock behavior
      when(() => storage.saveToken(any())).thenAnswer((_) async {});
      when(() => storage.deleteToken()).thenAnswer((_) async {});

      // Use a list to simulate changing return values
      final tokenValues = ['test_token', null];
      when(() => storage.getToken())
          .thenAnswer((_) async => tokenValues.removeAt(0));

      // Test the behavior
      await storage.saveToken('test_token');
      var token = await storage.getToken();
      expect(token, isNotNull);

      await storage.deleteToken();
      token = await storage.getToken();
      expect(token, isNull);
    });
  });
}

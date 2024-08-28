import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/domain/datasource/auth_local_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements IAuthLocalDataSource {}

void main() {
  late MockAuthLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthLocalDataSource();
  });

  group('IAuthLocalDataSource Tests', () {
    test('isAuthenticated should return true when authenticated', () async {
      // Arrange
      when(() => mockDataSource.isAuthenticated())
          .thenAnswer((_) async => true);

      // Act
      final result = await mockDataSource.isAuthenticated();

      // Assert
      expect(result, isTrue);
      verify(() => mockDataSource.isAuthenticated()).called(1);
    });

    test('isAuthenticated should return false when not authenticated',
        () async {
      // Arrange
      when(() => mockDataSource.isAuthenticated())
          .thenAnswer((_) async => false);

      // Act
      final result = await mockDataSource.isAuthenticated();

      // Assert
      expect(result, isFalse);
      verify(() => mockDataSource.isAuthenticated()).called(1);
    });

    test('isAuthenticated should throw exception on error', () async {
      // Arrange
      when(() => mockDataSource.isAuthenticated())
          .thenThrow(Exception('Local storage error'));

      // Act & Assert
      expect(() => mockDataSource.isAuthenticated(), throwsException);
    });
  });
}

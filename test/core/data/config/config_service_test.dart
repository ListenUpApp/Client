import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
  });

  group('ConfigService', () {
    test('initial grpcServerUrl is null when storage is empty', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final configService = ConfigService(mockSecureStorage);
      await Future.delayed(Duration.zero); // Allow async operations to complete

      expect(configService.grpcServerUrl, isNull);
      verify(() => mockSecureStorage.read(key: any(named: 'key'))).called(1);
    });

    test('initial grpcServerUrl is loaded from storage', () async {
      const testUrl = 'test.url';
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => testUrl);

      final configService = ConfigService(mockSecureStorage);
      await Future.delayed(Duration.zero); // Allow async operations to complete

      expect(configService.grpcServerUrl, equals(testUrl));
      verify(() => mockSecureStorage.read(key: any(named: 'key'))).called(1);
    });

    test('setGrpcServerUrl updates the url and stores it', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      final configService = ConfigService(mockSecureStorage);
      await Future.delayed(Duration.zero); // Allow async operations to complete

      const testUrl = 'new.test.url';
      await configService.setGrpcServerUrl(testUrl);

      expect(configService.grpcServerUrl, equals(testUrl));
      verify(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: testUrl,
          )).called(1);
    });

    test('setGrpcServerUrl notifies listeners', () async {
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      final configService = ConfigService(mockSecureStorage);
      await Future.delayed(Duration.zero); // Allow async operations to complete

      var notified = false;
      configService.addListener(() {
        notified = true;
      });

      await configService.setGrpcServerUrl('test.url');

      expect(notified, isTrue);
    });

    test('clearGrpcServerUrl clears the url and removes it from storage',
        () async {
      const testUrl = 'test.url';
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => testUrl);
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      final configService = ConfigService(mockSecureStorage);
      await Future.delayed(Duration.zero); // Allow async operations to complete

      await configService.clearGrpcServerUrl();

      expect(configService.grpcServerUrl, isNull);
      verify(() => mockSecureStorage.delete(key: any(named: 'key'))).called(1);
    });
  });
}

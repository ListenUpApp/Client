import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late ConfigService configService;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    when(() => mockSecureStorage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    configService = ConfigService(mockSecureStorage);
  });

  group('ConfigService', () {
    test('initial grpcServerUrl is null', () {
      expect(configService.grpcServerUrl, isNull);
    });

    test('setGrpcServerUrl updates the url', () async {
      const testUrl = 'test.url';
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      await configService.setGrpcServerUrl(testUrl);
      expect(configService.grpcServerUrl, equals(testUrl));

      verify(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: testUrl,
          )).called(1);
    });

    test('setGrpcServerUrl notifies listeners', () async {
      const testUrl = 'test.url';
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      var notified = false;
      configService.addListener(() {
        notified = true;
      });

      await configService.setGrpcServerUrl(testUrl);

      expect(notified, isTrue);
    });

    test('clearGrpcServerUrl clears the url', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await configService.clearGrpcServerUrl();
      expect(configService.grpcServerUrl, isNull);

      verify(() => mockSecureStorage.delete(key: any(named: 'key'))).called(1);
    });

    test('ConfigService constructor loads the url from storage', () async {
      const testUrl = 'test.url';
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => testUrl);

      final newConfigService = ConfigService(mockSecureStorage);

      // Wait for the _loadGrpcServerUrl method to complete
      await Future.delayed(Duration.zero);

      expect(newConfigService.grpcServerUrl, equals(testUrl));
      verify(() => mockSecureStorage.read(key: any(named: 'key'))).called(1);
    });
  });
}

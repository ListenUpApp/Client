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
    configService = ConfigService(mockSecureStorage);
  });

  group('ConfigService', () {
    const testUrl = 'https://test.example.com';
    const grpcServerUrlKey = 'grpc_server_url';

    test('init should load gRPC server URL and set isLoaded to true', () async {
      when(() => mockSecureStorage.read(key: grpcServerUrlKey))
          .thenAnswer((_) async => testUrl);

      await configService.init();

      verify(() => mockSecureStorage.read(key: grpcServerUrlKey)).called(1);
      expect(configService.grpcServerUrl, equals(testUrl));
      expect(configService.getGrpcServerUrl(), completion(equals(testUrl)));
    });

    test('getGrpcServerUrl should initialize if not loaded', () async {
      when(() => mockSecureStorage.read(key: grpcServerUrlKey))
          .thenAnswer((_) async => testUrl);

      final result = await configService.getGrpcServerUrl();

      expect(result, equals(testUrl));
      verify(() => mockSecureStorage.read(key: grpcServerUrlKey)).called(1);
    });

    test('setGrpcServerUrl should update URL and persist it', () async {
      when(() => mockSecureStorage.write(key: grpcServerUrlKey, value: testUrl))
          .thenAnswer((_) async {});

      await configService.setGrpcServerUrl(testUrl);

      verify(() =>
              mockSecureStorage.write(key: grpcServerUrlKey, value: testUrl))
          .called(1);
      expect(configService.grpcServerUrl, equals(testUrl));
    });

    test('clearGrpcServerUrl should remove URL and delete from storage',
        () async {
      when(() => mockSecureStorage.delete(key: grpcServerUrlKey))
          .thenAnswer((_) async {});

      await configService.clearGrpcServerUrl();

      verify(() => mockSecureStorage.delete(key: grpcServerUrlKey)).called(1);
      expect(configService.grpcServerUrl, isNull);
    });

    test('ConfigService should notify listeners when URL changes', () async {
      when(() => mockSecureStorage.write(key: grpcServerUrlKey, value: testUrl))
          .thenAnswer((_) async {});

      var notified = false;
      configService.addListener(() {
        notified = true;
      });

      await configService.setGrpcServerUrl(testUrl);

      expect(notified, isTrue);
    });
  });
}

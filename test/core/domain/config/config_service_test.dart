import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/domain/config/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements IConfigService {}

void main() {
  late MockConfigService mockConfigService;

  setUp(() {
    mockConfigService = MockConfigService();
  });

  group('IConfigService Tests', () {
    test('setGrpcServerUrl sets the URL', () {
      const testUrl = 'https://test.com';
      mockConfigService.setGrpcServerUrl(testUrl);
      verify(() => mockConfigService.setGrpcServerUrl(testUrl)).called(1);
    });

    test('getGrpcServerUrl returns the URL', () async {
      const testUrl = 'https://test.com';
      when(() => mockConfigService.getGrpcServerUrl())
          .thenAnswer((_) async => testUrl);

      final result = await mockConfigService.getGrpcServerUrl();
      expect(result, equals(testUrl));
    });

    test('clearGrpcServerUrl clears the URL', () async {
      when(() => mockConfigService.clearGrpcServerUrl())
          .thenAnswer((_) async => Future<void>.value());

      await mockConfigService.clearGrpcServerUrl();
      verify(() => mockConfigService.clearGrpcServerUrl()).called(1);
    });

    test('grpcServerUrl getter returns the URL', () {
      const testUrl = 'https://test.com';
      when(() => mockConfigService.grpcServerUrl).thenReturn(testUrl);

      final result = mockConfigService.grpcServerUrl;
      expect(result, equals(testUrl));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/data/config/config_service.dart';

void main() {
  late ConfigService configService;

  setUp(() {
    configService = ConfigService();
  });

  group('ConfigServiceImplementation', () {
    test('initial grpcServerUrl is null', () {
      expect(configService.grpcServerUrl, isNull);
    });

    test('setGrpcServerUrl updates the url', () {
      const testUrl = 'test.url';
      configService.setGrpcServerUrl(testUrl);
      expect(configService.grpcServerUrl, equals(testUrl));
    });

    test('setGrpcServerUrl notifies listeners', () {
      const testUrl = 'test.url';
      var notified = false;
      configService.addListener(() {
        notified = true;
      });

      configService.setGrpcServerUrl(testUrl);

      expect(notified, isTrue);
    });
  });
}

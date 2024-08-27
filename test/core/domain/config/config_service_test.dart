import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockChangeNotifier extends Mock implements ChangeNotifier {}

class TestableConfigServiceImplementation extends ConfigService {
  final MockChangeNotifier mockNotifier = MockChangeNotifier();

  @override
  void notifyListeners() {
    mockNotifier.notifyListeners();
  }
}

void main() {
  group('ConfigServiceImplementation', () {
    late TestableConfigServiceImplementation configService;

    setUp(() {
      configService = TestableConfigServiceImplementation();
    });

    test('initial grpcServerUrl is null', () {
      expect(configService.grpcServerUrl, isNull);
    });

    test('setGrpcServerUrl updates the value', () {
      const testUrl = 'test.example.com';
      configService.setGrpcServerUrl(testUrl);
      expect(configService.grpcServerUrl, equals(testUrl));
    });

    test('setGrpcServerUrl notifies listeners', () {
      const testUrl = 'test.example.com';
      configService.setGrpcServerUrl(testUrl);
      verify(() => configService.mockNotifier.notifyListeners()).called(1);
    });
  });
}

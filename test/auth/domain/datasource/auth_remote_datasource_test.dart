import 'package:flutter_test/flutter_test.dart';
import 'package:listenup/auth/domain/datasource/auth_remote_datasource.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements IAuthRemoteDataSource {}

void main() {
  group('IAuthRemoteDataSource Tests', () {
    late MockAuthRemoteDataSource dataSource;

    setUp(() {
      dataSource = MockAuthRemoteDataSource();
    });

    test('pingServer returns PingResponse', () async {
      when(() => dataSource.pingServer())
          .thenAnswer((_) async => PingResponse());

      final result = await dataSource.pingServer();
      expect(result, isA<PingResponse>());
    });

    test('loginUser returns LoginResponse', () async {
      final request = LoginRequest(/* add necessary parameters here */);
      when(() => dataSource.loginUser(request))
          .thenAnswer((_) async => LoginResponse());

      final result = await dataSource.loginUser(request);
      expect(result, isA<LoginResponse>());
    });

    test('registerUser returns RegisterResponse', () async {
      final request = RegisterRequest(/* add necessary parameters here */);
      when(() => dataSource.registerUser(request))
          .thenAnswer((_) async => RegisterResponse());

      final result = await dataSource.registerUser(request);
      expect(result, isA<RegisterResponse>());
    });
  });
}

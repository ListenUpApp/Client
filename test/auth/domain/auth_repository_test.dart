import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/domain/auth_repository.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('IAuthRepository Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    test('pingServer returns ResultFuture<PingResponse>', () async {
      final request = PingRequest();
      when(() => repository.pingServer(request: request))
          .thenAnswer((_) async => Right(PingResponse()));

      final result = await repository.pingServer(request: request);
      expect(result, isA<Either<Failure, PingResponse>>());
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected Right, but got Left(Failure)'),
          (response) => expect(response, isA<PingResponse>()));
    });

    test('loginUser returns ResultFuture<LoginResponse>', () async {
      final request = LoginRequest(/* add necessary parameters here */);
      when(() => repository.loginUser(request: request))
          .thenAnswer((_) async => Right(LoginResponse()));

      final result = await repository.loginUser(request: request);
      expect(result, isA<Either<Failure, LoginResponse>>());
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected Right, but got Left(Failure)'),
          (response) => expect(response, isA<LoginResponse>()));
    });

    test('registerUser returns ResultFuture<RegisterResponse>', () async {
      final request = RegisterRequest(/* add necessary parameters here */);
      when(() => repository.registerUser(request: request))
          .thenAnswer((_) async => Right(RegisterResponse()));

      final result = await repository.registerUser(request: request);
      expect(result, isA<Either<Failure, RegisterResponse>>());
      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected Right, but got Left(Failure)'),
          (response) => expect(response, isA<RegisterResponse>()));
    });
  });
}

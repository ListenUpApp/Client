import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/auth/presentation/bloc/login/login_bloc.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthBloc extends Mock implements AuthBloc {}

class MockLoginRequest extends Mock implements LoginRequest {}

void main() {
  late LoginBloc loginBloc;
  late MockAuthRepository mockAuthRepository;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(MockLoginRequest());
    registerFallbackValue(const AuthStatusChanged(true));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthBloc = MockAuthBloc();
    loginBloc = LoginBloc(mockAuthRepository, mockAuthBloc);
  });

  tearDown(() {
    loginBloc.close();
  });

  group('LoginBloc', () {
    test('initial state is LoginInitial', () {
      expect(loginBloc.state, isA<LoginInitial>());
      expect((loginBloc.state as LoginInitial).email, isEmpty);
      expect((loginBloc.state as LoginInitial).password, isEmpty);
    });

    blocTest<LoginBloc, LoginState>(
      'emits [LoginInitial] when LoginEmailChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const LoginEmailChanged('test@example.com')),
      expect: () => [
        isA<LoginInitial>()
            .having((state) => state.email, 'email', equals('test@example.com'))
            .having((state) => state.password, 'password', isEmpty),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginInitial] when LoginPasswordChanged is added',
      build: () => loginBloc,
      act: (bloc) => bloc.add(const LoginPasswordChanged('password123')),
      expect: () => [
        isA<LoginInitial>()
            .having((state) => state.email, 'email', isEmpty)
            .having(
                (state) => state.password, 'password', equals('password123')),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when LoginSubmitClicked is added and login is successful',
      build: () {
        when(() => mockAuthRepository.loginUser(request: any(named: 'request')))
            .thenAnswer((_) async => Right(LoginResponse()));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmitClicked(
          email: 'test@example.com', password: 'password123')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.loginUser(request: any(named: 'request')))
            .called(1);
        verify(() => mockAuthBloc.add(any(that: isA<AuthStatusChanged>())))
            .called(1);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginFailure] when LoginSubmitClicked is added and login fails',
      build: () {
        when(() => mockAuthRepository.loginUser(request: any(named: 'request')))
            .thenAnswer((_) async =>
                Left(GrpcFailure(code: 0, message: 'Login failed')));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmitClicked(
          email: 'test@example.com', password: 'password123')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having((state) => state.errorMessage,
            'errorMessage', contains('Login failed')),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.loginUser(request: any(named: 'request')))
            .called(1);
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginFailure] when LoginSubmitClicked is added and an exception is thrown',
      build: () {
        when(() => mockAuthRepository.loginUser(request: any(named: 'request')))
            .thenThrow(Exception('Unexpected error'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(const LoginSubmitClicked(
          email: 'test@example.com', password: 'password123')),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having((state) => state.errorMessage,
            'errorMessage', contains('Unexpected error')),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.loginUser(request: any(named: 'request')))
            .called(1);
        verifyNever(() => mockAuthBloc.add(any()));
      },
    );
  });
}

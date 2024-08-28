import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/auth/presentation/bloc/register/register_bloc.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthBloc extends Mock implements AuthBloc {}

class FakeRegisterRequest extends Fake implements RegisterRequest {}

void main() {
  late RegistrationBloc registrationBloc;
  late MockAuthRepository mockAuthRepository;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakeRegisterRequest());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockAuthBloc = MockAuthBloc();
    registrationBloc = RegistrationBloc(mockAuthRepository, mockAuthBloc);
  });

  tearDown(() {
    registrationBloc.close();
  });

  group('RegistrationBloc', () {
    test('initial state is correct', () {
      expect(registrationBloc.state,
          const RegistrationInitial(name: '', email: '', password: ''));
    });

    blocTest<RegistrationBloc, RegistrationState>(
      'emits new state when RegistrationNameChanged is added',
      build: () => registrationBloc,
      act: (bloc) => bloc.add(const RegistrationNameChanged('John Doe')),
      expect: () => [
        isA<RegistrationInitial>()
            .having((state) => state.name, 'name', 'John Doe')
            .having((state) => state.email, 'email', '')
            .having((state) => state.password, 'password', ''),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits new state when RegistrationEmailChanged is added',
      build: () => registrationBloc,
      act: (bloc) =>
          bloc.add(const RegistrationEmailChanged('john@example.com')),
      expect: () => [
        isA<RegistrationInitial>()
            .having((state) => state.name, 'name', '')
            .having((state) => state.email, 'email', 'john@example.com')
            .having((state) => state.password, 'password', ''),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits new state when RegistrationPasswordChanged is added',
      build: () => registrationBloc,
      act: (bloc) => bloc.add(const RegistrationPasswordChanged('password123')),
      expect: () => [
        isA<RegistrationInitial>()
            .having((state) => state.name, 'name', '')
            .having((state) => state.email, 'email', '')
            .having((state) => state.password, 'password', 'password123'),
      ],
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits [RegistrationLoading, RegistrationSuccess] when registration is successful',
      build: () {
        when(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .thenAnswer((_) async => Right(RegisterResponse()));
        return registrationBloc;
      },
      act: (bloc) => bloc.add(const RegistrationSubmitClicked(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123')),
      expect: () => [
        isA<RegistrationLoading>(),
        isA<RegistrationSuccess>(),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .called(1);
        verify(() => mockAuthBloc.add(const AuthCheckRequested())).called(1);
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits [RegistrationLoading, RegistrationFailure] when registration fails',
      build: () {
        when(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .thenAnswer(
                (_) async => Left(GrpcFailure(code: 0, message: "error")));
        return registrationBloc;
      },
      act: (bloc) => bloc.add(const RegistrationSubmitClicked(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123')),
      expect: () => [
        isA<RegistrationLoading>(),
        isA<RegistrationFailure>().having(
          (state) => state.errorMessage,
          'errorMessage',
          'GrpcFailure(code: 0, message: error)',
        ),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .called(1);
        verifyNever(() => mockAuthBloc.add(const AuthCheckRequested()));
      },
    );

    blocTest<RegistrationBloc, RegistrationState>(
      'emits [RegistrationLoading, RegistrationFailure] when an exception occurs',
      build: () {
        when(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .thenThrow(Exception('Unexpected error'));
        return registrationBloc;
      },
      act: (bloc) => bloc.add(const RegistrationSubmitClicked(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123')),
      expect: () => [
        isA<RegistrationLoading>(),
        isA<RegistrationFailure>().having(
          (state) => state.errorMessage,
          'errorMessage',
          contains('Exception: Unexpected error'),
        ),
      ],
      verify: (_) {
        verify(() =>
                mockAuthRepository.registerUser(request: any(named: 'request')))
            .called(1);
        verifyNever(() => mockAuthBloc.add(const AuthCheckRequested()));
      },
    );
  });
}

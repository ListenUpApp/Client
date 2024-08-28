import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/data/server/server_repository.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockServerRepository extends Mock implements ServerRepository {}

class MockConfigService extends Mock implements ConfigService {}

class FakeGetServerRequest extends Fake implements GetServerRequest {}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;
  late MockServerRepository mockServerRepository;
  late MockConfigService mockConfigService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockServerRepository = MockServerRepository();
    mockConfigService = MockConfigService();
    authBloc = AuthBloc(
      authRepository: mockAuthRepository,
      serverRepository: mockServerRepository,
      configService: mockConfigService,
    );
  });

  setUpAll(() {
    registerFallbackValue(FakeGetServerRequest());
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, const AuthInitial());
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthServerUrlNotSet] when server URL is not set',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthServerUrlNotSet()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when user is authenticated',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => const Right(true));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when user is not authenticated and server is set up',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => const Right(false));
          when(() =>
              mockServerRepository.getServer(
                  request: any(named: 'request'))).thenAnswer((_) async =>
              Right(GetServerResponse()..server = (Server()..isSetUp = true)));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSetupRequired] when user is not authenticated and server is not set up',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => const Right(false));
          when(() =>
              mockServerRepository.getServer(
                  request: any(named: 'request'))).thenAnswer((_) async =>
              Right(GetServerResponse()..server = (Server()..isSetUp = false)));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthSetupRequired()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthServerUrlNotSet] when getServer fails',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => const Right(false));
          when(() =>
              mockServerRepository.getServer(
                  request: any(named: 'request'))).thenAnswer(
              (_) async => Left(GrpcFailure(code: 0, message: 'Server error')));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthServerUrlNotSet()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when an exception occurs',
        build: () {
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenThrow(Exception('Unexpected error'));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthCheckRequested()),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
      );
    });

    group('ServerUrlSet', () {
      blocTest<AuthBloc, AuthState>(
        'calls setGrpcServerUrl and adds AuthCheckRequested',
        build: () {
          when(() => mockConfigService.setGrpcServerUrl(any()))
              .thenAnswer((_) async {});
          when(() => mockConfigService.getGrpcServerUrl())
              .thenAnswer((_) async => 'http://example.com');
          when(() => mockAuthRepository.isAuthenticated())
              .thenAnswer((_) async => const Right(false));
          when(() =>
              mockServerRepository.getServer(
                  request: any(named: 'request'))).thenAnswer((_) async =>
              Right(GetServerResponse()..server = (Server()..isSetUp = true)));
          return authBloc;
        },
        act: (bloc) => bloc.add(const ServerUrlSet('http://example.com')),
        expect: () => [const AuthLoading(), const AuthUnauthenticated()],
        verify: (_) {
          verify(() => mockConfigService.setGrpcServerUrl('http://example.com'))
              .called(1);
        },
      );
    });

    group('AuthStatusChanged', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthAuthenticated] when isAuthenticated is true',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthStatusChanged(true)),
        expect: () => [const AuthAuthenticated()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthUnauthenticated] when isAuthenticated is false',
        build: () => authBloc,
        act: (bloc) => bloc.add(const AuthStatusChanged(false)),
        expect: () => [const AuthUnauthenticated()],
      );
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_state.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockConfigService extends Mock implements ConfigService {}

class FakePingRequest extends Fake implements PingRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePingRequest());
  });

  late UrlBloc urlBloc;
  late MockAuthRepository mockAuthRepository;
  late MockConfigService mockConfigService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockConfigService = MockConfigService();
    urlBloc = UrlBloc(mockAuthRepository, mockConfigService);
  });

  tearDown(() {
    urlBloc.close();
  });

  test('initial state is correct', () {
    expect(urlBloc.state, isA<UrlInitial>());
  });

  group('UrlChanged', () {
    blocTest<UrlBloc, UrlState>(
      'emits UrlInitial state',
      build: () => urlBloc,
      act: (bloc) => bloc.add(const UrlChanged('https://example.com')),
      expect: () => [isA<UrlInitial>()],
    );
  });

  group('SubmitButtonPressed', () {
    const testUrl = 'https://example.com';

    void arrangeAuthRepositoryPingSuccess() {
      when(() => mockAuthRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Right(PingResponse()));
    }

    void arrangeAuthRepositoryPingGrpcFailure() {
      when(() => mockAuthRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async => Left(GrpcFailure(
              code: StatusCode.unavailable, message: 'Server unavailable')));
    }

    void arrangeAuthRepositoryPingUnexpectedFailure() {
      when(() => mockAuthRepository.pingServer(request: any(named: 'request')))
          .thenAnswer((_) async =>
              Left(UnexpectedFailure('Unexpected error occurred')));
    }

    setUp(() {
      // when(() => mockConfigService.setGrpcServerUrl(any())).thenReturn(null);
    });

    blocTest<UrlBloc, UrlState>(
      'emits UrlLoading and then UrlLoadSuccess when ping is successful',
      build: () {
        arrangeAuthRepositoryPingSuccess();
        return urlBloc;
      },
      act: (bloc) => bloc.add(const SubmitButtonPressed(testUrl)),
      expect: () => [
        isA<UrlLoading>(),
        isA<UrlLoadSuccess>(),
      ],
    );

    blocTest<UrlBloc, UrlState>(
      'emits UrlLoading and then UrlLoadFailure when ping fails with GrpcFailure',
      build: () {
        arrangeAuthRepositoryPingGrpcFailure();
        return urlBloc;
      },
      act: (bloc) => bloc.add(const SubmitButtonPressed(testUrl)),
      expect: () => [
        isA<UrlLoading>(),
        isA<UrlLoadFailure>().having(
          (state) => state.error,
          'error',
          contains('Server unavailable'),
        ),
      ],
    );

    blocTest<UrlBloc, UrlState>(
      'emits UrlLoading and then UrlLoadFailure when ping fails with UnexpectedFailure',
      build: () {
        arrangeAuthRepositoryPingUnexpectedFailure();
        return urlBloc;
      },
      act: (bloc) => bloc.add(const SubmitButtonPressed(testUrl)),
      expect: () => [
        isA<UrlLoading>(),
        isA<UrlLoadFailure>().having(
          (state) => state.error,
          'error',
          contains('Unexpected error occurred'),
        ),
      ],
    );
  });
}

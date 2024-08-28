import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_bloc.dart';
import 'package:listenup/auth/presentation/bloc/url/url_state.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockConfigService extends Mock implements ConfigService {}

class MockAuthBloc extends Mock implements AuthBloc {}

class FakePingRequest extends Fake implements PingRequest {}

// Custom matcher for ServerUrlSet
class IsServerUrlSet extends Matcher {
  final String expectedUrl;

  IsServerUrlSet(this.expectedUrl);

  @override
  bool matches(item, Map matchState) {
    return item is ServerUrlSet && item.url == expectedUrl;
  }

  @override
  Description describe(Description description) {
    return description.add('is ServerUrlSet with url $expectedUrl');
  }
}

void main() {
  late UrlBloc urlBloc;
  late MockAuthRepository mockAuthRepository;
  late MockConfigService mockConfigService;
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(FakePingRequest());
    registerFallbackValue(const ServerUrlSet(''));
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockConfigService = MockConfigService();
    mockAuthBloc = MockAuthBloc();

    when(() => mockConfigService.grpcServerUrl).thenReturn('');
    when(() => mockConfigService.setGrpcServerUrl(any()))
        .thenAnswer((_) async {});
    when(() => mockConfigService.clearGrpcServerUrl()).thenAnswer((_) async {});

    urlBloc = UrlBloc(mockAuthRepository, mockConfigService, mockAuthBloc);
  });

  tearDown(() {
    urlBloc.close();
  });

  group('UrlBloc', () {
    test('initial state is UrlInitial with empty string', () {
      expect(urlBloc.state, isA<UrlInitial>());
      expect((urlBloc.state as UrlInitial).url, isEmpty);
    });

    blocTest<UrlBloc, UrlState>(
      'emits [UrlInitial] when UrlChanged is added',
      build: () => urlBloc,
      act: (bloc) => bloc.add(const UrlChanged('https://newurl.com')),
      expect: () => [isA<UrlInitial>()],
      verify: (bloc) =>
          expect((bloc.state as UrlInitial).url, equals('https://newurl.com')),
    );

    blocTest<UrlBloc, UrlState>(
      'emits [UrlLoading, UrlLoadSuccess] when SubmitButtonPressed is added and ping is successful',
      build: () {
        when(() =>
                mockAuthRepository.pingServer(request: any(named: 'request')))
            .thenAnswer((_) async => Right(PingResponse()));
        return urlBloc;
      },
      act: (bloc) =>
          bloc.add(const SubmitButtonPressed('https://validurl.com')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<UrlLoading>(),
        isA<UrlLoadSuccess>(),
      ],
      verify: (_) {
        verify(() => mockConfigService.setGrpcServerUrl('https://validurl.com'))
            .called(1);
        verify(() =>
                mockAuthRepository.pingServer(request: any(named: 'request')))
            .called(1);
        verify(() => mockAuthBloc
            .add(any(that: IsServerUrlSet('https://validurl.com')))).called(1);
      },
    );

    blocTest<UrlBloc, UrlState>(
      'emits [UrlLoading, UrlLoadFailure] when SubmitButtonPressed is added and ping fails',
      build: () {
        when(() =>
                mockAuthRepository.pingServer(request: any(named: 'request')))
            .thenAnswer((_) async =>
                Left(GrpcFailure(code: 0, message: 'Connection failed')));
        return urlBloc;
      },
      act: (bloc) =>
          bloc.add(const SubmitButtonPressed('https://invalidurl.com')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<UrlLoading>(),
        isA<UrlLoadFailure>(),
      ],
      verify: (_) {
        verify(() =>
                mockConfigService.setGrpcServerUrl('https://invalidurl.com'))
            .called(1);
        verify(() =>
                mockAuthRepository.pingServer(request: any(named: 'request')))
            .called(1);
        verify(() => mockConfigService.clearGrpcServerUrl()).called(1);
      },
    );

    blocTest<UrlBloc, UrlState>(
      'emits [UrlLoadSuccess] when LoadSavedUrl is added and there is a saved URL',
      build: () {
        when(() => mockConfigService.grpcServerUrl)
            .thenReturn('https://savedurl.com');
        return UrlBloc(mockAuthRepository, mockConfigService, mockAuthBloc);
      },
      act: (bloc) => bloc.add(const LoadSavedUrl()),
      expect: () => [isA<UrlLoadSuccess>()],
      verify: (bloc) => expect(
          (bloc.state as UrlLoadSuccess).url, equals('https://savedurl.com')),
    );

    blocTest<UrlBloc, UrlState>(
      'emits [UrlInitial] with empty string when LoadSavedUrl is added and there is no saved URL',
      build: () {
        when(() => mockConfigService.grpcServerUrl).thenReturn(null);
        return UrlBloc(mockAuthRepository, mockConfigService, mockAuthBloc);
      },
      act: (bloc) => bloc.add(const LoadSavedUrl()),
      expect: () => [isA<UrlInitial>()],
      verify: (bloc) => expect((bloc.state as UrlInitial).url, isEmpty),
    );
  });
}

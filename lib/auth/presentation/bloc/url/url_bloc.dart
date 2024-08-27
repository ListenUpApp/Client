import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:logger/logger.dart';

import '../../../../core/data/config/config_service.dart';
import '../../../data/auth_repository.dart';
import '../auth/auth_bloc.dart';
import 'url_state.dart';

part 'url_event.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  final AuthRepository _authRepository;
  final ConfigService _configService;
  final AuthBloc _authBloc;
  final _log = Logger();

  UrlBloc(this._authRepository, this._configService, this._authBloc)
      : super(UrlInitial(_configService.grpcServerUrl ?? '')) {
    on<UrlChanged>(_onUrlChanged);
    on<SubmitButtonPressed>(_onSubmitClicked);
    on<LoadSavedUrl>(_onLoadSavedUrl);
  }

  void _onUrlChanged(UrlChanged event, Emitter<UrlState> emit) {
    emit(UrlInitial(event.url));
  }

  Future<void> _onSubmitClicked(
      SubmitButtonPressed event, Emitter<UrlState> emit) async {
    emit(UrlLoading(event.url));
    try {
      await _configService.setGrpcServerUrl(event.url);
      final result = await _authRepository.pingServer(request: PingRequest());
      result.fold(
        (failure) {
          _log.w(
              {'message': 'Server ping failed', 'error': failure.toString()});
          emit(UrlLoadFailure(
              event.url, 'Failed to connect to server: ${failure.toString()}'));
          _configService.clearGrpcServerUrl();
        },
        (success) {
          _log.i({'message': 'Server ping successful'});
          _authBloc.add(ServerUrlSet(event.url));
          emit(UrlLoadSuccess(event.url));
        },
      );
    } catch (e) {
      await _configService.clearGrpcServerUrl();
      _log.e({'message': 'Server ping failed', 'error': e.toString()});
      emit(UrlLoadFailure(event.url, "An error occurred: ${e.toString()}"));
    }
  }

  void _onLoadSavedUrl(LoadSavedUrl event, Emitter<UrlState> emit) {
    final savedUrl = _configService.grpcServerUrl;
    if (savedUrl != null && savedUrl.isNotEmpty) {
      emit(UrlLoadSuccess(savedUrl));
    } else {
      emit(const UrlInitial(''));
    }
  }
}

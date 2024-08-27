import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/core/data/config/config_service.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'url_event.dart';
part 'url_state.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  final AuthRepository _authRepository;
  final ConfigService _configService;
  final _log = Logger();
  UrlBloc(this._authRepository, this._configService) : super(const UrlState()) {
    on<UrlPingSuccess>(_onPingSuccess);
    on<UrlErrorOccurred>(_onErrorOccurred);
    on<SubmitButtonPressed>(_onSubmitClicked);
  }

  void _onPingSuccess(UrlPingSuccess event, Emitter<UrlState> emit) {
    emit(state.copyWith(isPinging: false, canSubmit: false, pingSuccess: true));
  }

  void _onErrorOccurred(UrlErrorOccurred event, Emitter<UrlState> emit) {
    emit(state.copyWith(
        isPinging: false,
        canSubmit: false,
        pingSuccess: false,
        error: event.message));
  }

  void _onUrlChange(String url, Emitter<UrlState> emit) {
    emit(state.copyWith(url: url));
  }

  Future<void> _onSubmitClicked(
      SubmitButtonPressed event, Emitter<UrlState> emit) async {
    emit(state.copyWith(isPinging: true));
    try {
      _configService.setGrpcServerUrl(event.url);
      final result = await _authRepository.pingServer(request: PingRequest());
      result.fold(
        (failure) {
          _log.w('Server ping failed after setting address: $failure');
          add(
            UrlErrorOccurred(
                'Failed to connect to server: ${failure.toString()}'),
          );
          _configService.setGrpcServerUrl('');
        },
        (success) {
          _log.i('Server ping successful after setting address');
          add(UrlPingSuccess());
        },
      );
    } catch (e) {
      _configService.setGrpcServerUrl('');
      _log.e('Server ping failed after setting address: $e');
      add(UrlErrorOccurred("An error occurred ${e}"));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:logger/logger.dart';

import '../../../../core/data/config/config_service.dart';
import '../../../data/auth_repository.dart';
import 'url_state.dart';

part 'url_event.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  final AuthRepository _authRepository;
  final ConfigService _configService;
  final _log = Logger();

  UrlBloc(this._authRepository, this._configService)
      : super(const UrlInitial()) {
    on<UrlChanged>(_onUrlChanged);
    on<SubmitButtonPressed>(_onSubmitClicked);
  }

  void _onUrlChanged(UrlChanged event, Emitter<UrlState> emit) {
    emit(const UrlInitial());
  }

  Future<void> _onSubmitClicked(
      SubmitButtonPressed event, Emitter<UrlState> emit) async {
    emit(UrlLoading(event.url));
    try {
      _configService.setGrpcServerUrl(event.url);
      final result = await _authRepository.pingServer(request: PingRequest());
      result.fold(
        (failure) {
          _log.w(
              {'message': 'Server ping failed', 'error': failure.toString()});
          emit(UrlLoadFailure(
              event.url, 'Failed to connect to server: ${failure.toString()}'));
          _configService.setGrpcServerUrl('');
        },
        (success) {
          _log.i({'message': 'Server ping successful'});
          emit(UrlLoadSuccess(event.url));
        },
      );
    } catch (e) {
      _configService.setGrpcServerUrl('');
      _log.e({'message': 'Server ping failed', 'error': e.toString()});
      emit(UrlLoadFailure(event.url, "An error occurred: ${e.toString()}"));
    }
  }
}

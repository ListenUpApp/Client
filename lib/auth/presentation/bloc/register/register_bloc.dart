import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  final _log = Logger();
  RegistrationBloc(this._authRepository, this._authBloc)
      : super(const RegistrationState()) {
    on<RegistrationSubmitClicked>(_onSubmitClick);
    on<RegistrationSuccess>(_onRegistrationSuccess);
    on<RegistrationErrorOccurred>(_onErrorOccurred);
  }

  void _onRegistrationSuccess(
      RegistrationSuccess event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(isRegistering: false));
  }

  void _onErrorOccurred(
      RegistrationErrorOccurred event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(isRegistering: false));
  }

  void onNameChange(String name, Emitter<RegistrationState> emit) {
    emit(state.copyWith(name: name));
  }

  void onEmailChange(String email, Emitter<RegistrationState> emit) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChange(String password, Emitter<RegistrationState> emit) {
    emit(state.copyWith(password: password));
  }

  void _onSubmitClick(
      RegistrationSubmitClicked event, Emitter<RegistrationState> emit) async {
    emit(state.copyWith(isRegistering: true));
    try {
      final request = RegisterRequest(
          name: event.name, email: event.email, password: event.password);
      final result = await _authRepository.registerUser(request: request);
      result.fold((failure) {
        _log.w({'message': 'Server ping failed', 'error': failure.toString()});
        add(RegistrationErrorOccurred(failure.toString()));
      }, (result) {
        emit(state.copyWith(isRegistering: false));
        add(RegistrationSuccess());
        _authBloc.add(AuthCheckRequested());
      });
    } catch (e) {
      _log.e({'message': 'Server ping failed', 'error': e.toString()});
    }
  }
}

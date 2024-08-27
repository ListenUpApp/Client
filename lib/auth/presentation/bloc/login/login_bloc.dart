import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:meta/meta.dart';

import '../auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  LoginBloc(this._authRepository, this._authBloc) : super(const LoginState()) {
    on<LoginSuccess>(_onLoginSuccess);
    on<LoginErrorOccurred>(_onErrorOccurred);
    on<LoginSubmitClicked>(_onSubmitClick);
  }

  void _onLoginSuccess(LoginSuccess event, Emitter<LoginState> emit) {
    emit(state.copyWith(isLoggingIn: false));
  }

  void _onErrorOccurred(LoginErrorOccurred event, Emitter<LoginState> emit) {
    emit(state.copyWith(isLoggingIn: false));
  }

  void onEmailChange(String email, Emitter<LoginState> emit) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChange(String password, Emitter<LoginState> emit) {
    emit(state.copyWith(password: password));
  }

  void _onSubmitClick(
      LoginSubmitClicked event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoggingIn: true));
    try {
      final request =
          LoginRequest(email: event.email, password: event.password);
      final result = await _authRepository.loginUser(request: request);
      result.fold(
        (failure) {
          emit(state.copyWith(isLoggingIn: false));
        },
        (success) {
          _authBloc.add(const AuthStatusChanged(true));
          emit(state.copyWith(isLoggingIn: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoggingIn: false));
    }
  }
}

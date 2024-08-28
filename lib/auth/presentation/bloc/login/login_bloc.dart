import 'package:bloc/bloc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pbgrpc.dart';
import 'package:meta/meta.dart';

import '../auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  LoginBloc(this._authRepository, this._authBloc)
      : super(const LoginInitial(email: '', password: '')) {
    on<LoginEvent>((event, emit) {
      switch (event) {
        case LoginSubmitClicked():
          _onSubmitClick(event, emit);
        case LoginEmailChanged():
          _onEmailChanged(event, emit);
        case LoginPasswordChanged():
          _onPasswordChanged(event, emit);
      }
    });
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(LoginInitial(email: event.email, password: state.password));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(LoginInitial(email: state.email, password: event.password));
  }

  Future<void> _onSubmitClick(
    LoginSubmitClicked event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading(email: event.email, password: event.password));

    try {
      final request =
          LoginRequest(email: event.email, password: event.password);
      final result = await _authRepository.loginUser(request: request);

      result.fold(
        (failure) {
          emit(LoginFailure(
            email: event.email,
            password: event.password,
            errorMessage: failure.toString(),
          ));
        },
        (success) {
          _authBloc.add(const AuthStatusChanged(true));
          emit(LoginSuccess(email: event.email, password: event.password));
        },
      );
    } catch (e) {
      emit(LoginFailure(
        email: event.email,
        password: event.password,
        errorMessage: e.toString(),
      ));
    }
  }
}

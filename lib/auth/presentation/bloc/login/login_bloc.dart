import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginSuccess>(_onLoginSuccess);
    on<LoginErrorOccurred>(_onErrorOccurred);
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

  void onSubmitClick(Emitter<LoginState> emit) {
    emit(state.copyWith(isLoggingIn: true));
    // Implement login logic here
  }
}

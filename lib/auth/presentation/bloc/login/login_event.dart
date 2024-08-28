part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {
  const LoginEvent();
}

final class LoginSubmitClicked extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitClicked({required this.email, required this.password});
}

final class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);
}

final class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);
}

part of 'login_bloc.dart';

@immutable
sealed class LoginState {
  final String email;
  final String password;

  const LoginState({required this.email, required this.password});
}

final class LoginInitial extends LoginState {
  const LoginInitial({required super.email, required super.password});
}

final class LoginLoading extends LoginState {
  const LoginLoading({required super.email, required super.password});
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required super.email, required super.password});
}

final class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure({
    required super.email,
    required super.password,
    required this.errorMessage,
  });
}

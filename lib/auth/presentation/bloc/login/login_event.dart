part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSuccess extends LoginEvent {}

class LoginSubmitClicked extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitClicked({required this.email, required this.password});
}

class LoginErrorOccurred extends LoginEvent {
  final String message;
  const LoginErrorOccurred(this.message);

  @override
  List<Object> get props => [message];
}

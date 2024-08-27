part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class ServerUrlSet extends AuthEvent {
  final String url;

  const ServerUrlSet(this.url);

  @override
  List<Object> get props => [url];
}

class AuthStatusChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthStatusChanged(this.isAuthenticated);

  @override
  List<Object> get props => [isAuthenticated];
}

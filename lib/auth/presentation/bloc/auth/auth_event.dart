part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class ServerUrlSet extends AuthEvent {
  final String url;
  const ServerUrlSet(this.url);
}

final class AuthStatusChanged extends AuthEvent {
  final bool isAuthenticated;
  const AuthStatusChanged(this.isAuthenticated);
}

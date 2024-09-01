part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthServerUrlNotSet extends AuthState {
  const AuthServerUrlNotSet();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSetupRequired extends AuthState {
  const AuthSetupRequired();
}

final class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

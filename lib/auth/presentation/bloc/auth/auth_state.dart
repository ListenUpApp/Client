part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthServerUrlNotSet extends AuthState {
  const AuthServerUrlNotSet();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSetupRequired extends AuthState {
  const AuthSetupRequired();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

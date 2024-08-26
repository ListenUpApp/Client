part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isLoggingIn;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoggingIn = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoggingIn,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
    );
  }

  @override
  List<Object> get props => [email, password, isLoggingIn];
}

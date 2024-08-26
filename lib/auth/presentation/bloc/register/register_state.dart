part of 'register_bloc.dart';

@immutable
class RegistrationState extends Equatable {
  final String name;
  final String email;
  final String password;
  final bool isRegistering;

  const RegistrationState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isRegistering = false,
  });

  RegistrationState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isRegistering,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isRegistering: isRegistering ?? this.isRegistering,
    );
  }

  @override
  List<Object> get props => [name, email, password, isRegistering];
}

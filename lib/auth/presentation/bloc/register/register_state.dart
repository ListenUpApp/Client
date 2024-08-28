part of 'register_bloc.dart';

sealed class RegistrationState {
  final String name;
  final String email;
  final String password;

  const RegistrationState({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class RegistrationInitial extends RegistrationState {
  const RegistrationInitial({
    required super.name,
    required super.email,
    required super.password,
  });
}

final class RegistrationLoading extends RegistrationState {
  const RegistrationLoading({
    required super.name,
    required super.email,
    required super.password,
  });
}

final class RegistrationSuccess extends RegistrationState {
  const RegistrationSuccess({
    required super.name,
    required super.email,
    required super.password,
  });
}

final class RegistrationFailure extends RegistrationState {
  final String errorMessage;

  const RegistrationFailure({
    required super.name,
    required super.email,
    required super.password,
    required this.errorMessage,
  });
}

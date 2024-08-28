part of 'register_bloc.dart';

@immutable
sealed class RegistrationEvent {
  const RegistrationEvent();
}

final class RegistrationSubmitClicked extends RegistrationEvent {
  final String name;
  final String email;
  final String password;

  const RegistrationSubmitClicked({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class RegistrationNameChanged extends RegistrationEvent {
  final String name;
  const RegistrationNameChanged(this.name);
}

final class RegistrationEmailChanged extends RegistrationEvent {
  final String email;
  const RegistrationEmailChanged(this.email);
}

final class RegistrationPasswordChanged extends RegistrationEvent {
  final String password;
  const RegistrationPasswordChanged(this.password);
}

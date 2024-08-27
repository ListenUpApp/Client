part of 'register_bloc.dart';

@immutable
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegistrationSuccess extends RegistrationEvent {}

class RegistrationErrorOccurred extends RegistrationEvent {
  final String message;
  const RegistrationErrorOccurred(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationSubmitClicked extends RegistrationEvent {
  final String name;
  final String email;
  final String password;

  const RegistrationSubmitClicked(
      {required this.name, required this.email, required this.password});
}

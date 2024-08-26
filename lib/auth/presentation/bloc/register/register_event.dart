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

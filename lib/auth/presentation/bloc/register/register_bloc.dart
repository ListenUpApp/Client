import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(const RegistrationState()) {
    on<RegistrationSuccess>(_onRegistrationSuccess);
    on<RegistrationErrorOccurred>(_onErrorOccurred);
  }

  void _onRegistrationSuccess(
      RegistrationSuccess event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(isRegistering: false));
  }

  void _onErrorOccurred(
      RegistrationErrorOccurred event, Emitter<RegistrationState> emit) {
    emit(state.copyWith(isRegistering: false));
  }

  void onNameChange(String name, Emitter<RegistrationState> emit) {
    emit(state.copyWith(name: name));
  }

  void onEmailChange(String email, Emitter<RegistrationState> emit) {
    emit(state.copyWith(email: email));
  }

  void onPasswordChange(String password, Emitter<RegistrationState> emit) {
    emit(state.copyWith(password: password));
  }

  void onSubmitClick(Emitter<RegistrationState> emit) {
    emit(state.copyWith(isRegistering: true));
    // Implement registration logic here
  }
}

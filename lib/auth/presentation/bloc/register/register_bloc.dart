import 'package:bloc/bloc.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:listenup/generated/listenup/auth/v1/auth.pb.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  final _log = Logger();

  RegistrationBloc(this._authRepository, this._authBloc)
      : super(const RegistrationInitial(name: '', email: '', password: '')) {
    on<RegistrationEvent>((event, emit) {
      switch (event) {
        case RegistrationSubmitClicked():
          _onSubmitClick(event, emit);
        case RegistrationNameChanged():
          _onNameChanged(event, emit);
        case RegistrationEmailChanged():
          _onEmailChanged(event, emit);
        case RegistrationPasswordChanged():
          _onPasswordChanged(event, emit);
      }
    });
  }

  void _onNameChanged(
      RegistrationNameChanged event, Emitter<RegistrationState> emit) {
    emit(RegistrationInitial(
        name: event.name, email: state.email, password: state.password));
  }

  void _onEmailChanged(
      RegistrationEmailChanged event, Emitter<RegistrationState> emit) {
    emit(RegistrationInitial(
        name: state.name, email: event.email, password: state.password));
  }

  void _onPasswordChanged(
      RegistrationPasswordChanged event, Emitter<RegistrationState> emit) {
    emit(RegistrationInitial(
        name: state.name, email: state.email, password: event.password));
  }

  Future<void> _onSubmitClick(
    RegistrationSubmitClicked event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(RegistrationLoading(
        name: event.name, email: event.email, password: event.password));

    try {
      final request = RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      final result = await _authRepository.registerUser(request: request);

      result.fold(
        (failure) {
          _log.w(
              {'message': 'Registration failed', 'error': failure.toString()});
          emit(RegistrationFailure(
            name: event.name,
            email: event.email,
            password: event.password,
            errorMessage: failure.toString(),
          ));
        },
        (success) {
          emit(RegistrationSuccess(
              name: event.name, email: event.email, password: event.password));
          _authBloc.add(const AuthCheckRequested());
        },
      );
    } catch (e) {
      _log.e({'message': 'Registration error', 'error': e.toString()});
      emit(RegistrationFailure(
        name: event.name,
        email: event.email,
        password: event.password,
        errorMessage: e.toString(),
      ));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/core/data/server/server_repository.dart';
import 'package:listenup/generated/listenup/server/v1/server.pb.dart';
import 'package:meta/meta.dart';

import '../../../../core/data/config/config_service.dart';
import '../../../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final ServerRepository _serverRepository;
  final ConfigService _configService;

  AuthBloc({
    required AuthRepository authRepository,
    required ServerRepository serverRepository,
    required ConfigService configService,
  })  : _authRepository = authRepository,
        _serverRepository = serverRepository,
        _configService = configService,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<ServerUrlSet>(_onServerUrlSet);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final serverUrl = await _configService.getGrpcServerUrl();
    if (serverUrl == null || serverUrl.isEmpty) {
      emit(const AuthServerUrlNotSet());
      return;
    }

    final authResult = await _authRepository.isAuthenticated();
    await authResult.match(
      (failure) async => emit(const AuthUnauthenticated()),
      (isAuthenticated) async {
        if (isAuthenticated) {
          emit(const AuthAuthenticated());
        } else {
          await _checkServerSetup(emit);
        }
      },
    );
  }

  Future<void> _checkServerSetup(Emitter<AuthState> emit) async {
    final request = GetServerRequest();
    final setupResult = await _serverRepository.getServer(request: request);
    await setupResult.match(
      (failure) async => emit(const AuthServerUrlNotSet()),
      (response) async {
        if (response.server.isSetUp) {
          emit(const AuthUnauthenticated());
        } else {
          emit(const AuthSetupRequired());
        }
      },
    );
  }

  Future<void> _onServerUrlSet(
    ServerUrlSet event,
    Emitter<AuthState> emit,
  ) async {
    await _configService.setGrpcServerUrl(event.url);
    add(AuthCheckRequested());
  }

  void _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.isAuthenticated) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}

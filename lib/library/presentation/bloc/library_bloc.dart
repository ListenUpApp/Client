import 'package:bloc/bloc.dart';
import 'package:listenup/library/data/library_repository.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../generated/listenup/library/v1/library.pb.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _libraryRepository;
  final AuthBloc _authBloc;
  final _log = Logger();

  LibraryBloc(this._libraryRepository, this._authBloc)
      : super(const LibraryInitial()) {
    on<LoadLibraries>(_onLoadLibraries);
    on<SetCurrentLibrary>(_onSetCurrentLibrary);
  }

  Future<void> _onLoadLibraries(
      LoadLibraries event, Emitter<LibraryState> emit) async {
    emit(const LibraryLoading());

    final authState = _authBloc.state;
    if (authState is! AuthAuthenticated) {
      emit(const LibraryError('User is not authenticated'));
      return;
    }

    try {
      final request = GetLibrariesForUserRequest(userId: authState.user.id);
      final result =
          await _libraryRepository.getLibrariesForUser(request: request);

      result.fold(
        (failure) {
          _log.e('Failed to load libraries: $failure');
          emit(LibraryError(failure.toString()));
        },
        (response) {
          final libraries = response.libraries;
          final currentLibrary = libraries.cast<Library?>().firstWhere(
                (library) => library?.id == authState.user.currentLibraryId,
                orElse: () => null,
              );
          emit(LibraryLoaded(
            availableLibraries: libraries,
            currentLibrary: currentLibrary,
          ));
        },
      );
    } catch (e) {
      _log.e('Error loading libraries: $e');
      emit(LibraryError(e.toString()));
    }
  }

  void _onSetCurrentLibrary(
      SetCurrentLibrary event, Emitter<LibraryState> emit) {
    if (state is LibraryLoaded) {
      final currentState = state as LibraryLoaded;
      final newCurrentLibrary =
          currentState.availableLibraries.cast<Library?>().firstWhere(
                (library) => library?.id == event.libraryId,
                orElse: () => null,
              );

      if (newCurrentLibrary != null) {
        emit(LibraryLoaded(
          availableLibraries: currentState.availableLibraries,
          currentLibrary: newCurrentLibrary,
        ));
      }
    }
  }
}

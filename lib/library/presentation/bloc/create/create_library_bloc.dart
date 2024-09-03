import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:listenup/auth/data/auth_repository.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/data/library_repository.dart';
import 'package:listenup/library/presentation/bloc/library_bloc.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

part 'create_library_event.dart';
part 'create_library_state.dart';

class CreateLibraryBloc extends Bloc<CreateLibraryEvent, CreateLibraryState> {
  final LibraryRepository _libraryRepository;
  final AuthRepository _authRepository;
  final LibraryBloc _libraryBloc;
  CreateLibraryBloc(
      this._libraryRepository, this._authRepository, this._libraryBloc)
      : super(const CreateLibraryInitial()) {
    on<UpdateLibraryName>(_onUpdateLibraryName);
    on<LoadDirectories>(_onLoadDirectories);
    on<NavigateBack>(_onNavigateBack);
    on<AddFolderToLibrary>(_onAddFolderToLibrary);
    on<RemoveFolderFromLibrary>(_onRemoveFolderFromLibrary);
    on<CreateLibrary>(_onCreateLibrary);
  }

  void _onUpdateLibraryName(
      UpdateLibraryName event, Emitter<CreateLibraryState> emit) {
    final currentState = state;
    if (currentState is CreateLibraryLoaded) {
      emit(currentState.copyWith(name: event.name));
    } else {
      emit(CreateLibraryLoaded(
        name: event.name,
        currentFolders: const [],
        pathHistory: const [],
        currentLevel: 0,
        selectedFolders: const [],
      ));
    }
  }

  Future<void> _onLoadDirectories(
      LoadDirectories event, Emitter<CreateLibraryState> emit) async {
    emit(const CreateLibraryLoading());

    try {
      final currentState = state;
      List<String> newPathHistory;

      if (currentState is CreateLibraryLoaded) {
        newPathHistory = [...currentState.pathHistory, event.path];
      } else {
        newPathHistory = [event.path];
      }

      final request = GetFolderRequest()
        ..path = event.path
        ..level = event.level;

      final response = await _libraryRepository.getFolder(request: request);

      response.fold(
        (failure) => emit(CreateLibraryError(
            'Failed to load directories: ${failure.toString()}')),
        (getFolderResponse) => emit(CreateLibraryLoaded(
          name: currentState is CreateLibraryLoaded ? currentState.name : '',
          currentFolders: getFolderResponse.folders,
          pathHistory: newPathHistory,
          currentLevel: event.level,
          selectedFolders: currentState is CreateLibraryLoaded
              ? currentState.selectedFolders
              : [],
        )),
      );
    } catch (e) {
      emit(CreateLibraryError(e.toString()));
    }
  }

  void _onNavigateBack(NavigateBack event, Emitter<CreateLibraryState> emit) {
    final currentState = state;
    if (currentState is CreateLibraryLoaded) {
      if (currentState.currentLevel > 0) {
        final currentPath = currentState.pathHistory.last;
        final parentPath = path.dirname(currentPath);
        final previousLevel = currentState.currentLevel - 1;

        emit(const CreateLibraryLoading());
        add(LoadDirectories(parentPath, previousLevel));
      }
    }
  }

  void _onAddFolderToLibrary(
      AddFolderToLibrary event, Emitter<CreateLibraryState> emit) {
    final currentState = state;
    if (currentState is CreateLibraryLoaded) {
      final updatedSelectedFolders =
          List<Folder>.from(currentState.selectedFolders)..add(event.folder);
      emit(currentState.copyWith(selectedFolders: updatedSelectedFolders));
    }
  }

  Future<void> _onCreateLibrary(
      CreateLibrary event, Emitter<CreateLibraryState> emit) async {
    emit(const CreateLibraryLoading());

    final request =
        CreateLibraryRequest(name: event.name, folders: event.folders);

    try {
      final response = await _libraryRepository.createLibrary(request: request);

      await response.fold((failure) async {
        if (!emit.isDone) {
          emit(CreateLibraryError(
              'Failed to create library: ${failure.toString()}'));
        }
      }, (createdLibrary) async {
        final user = await _authRepository.retrieveLocalUser();
        if (user != null) {
          user.currentLibraryId = createdLibrary.library.id;
          _libraryBloc.add(LoadLibraries());
        }
        if (!emit.isDone) {
          emit(const CreateLibrarySuccess());
        }
      });
    } catch (e) {
      if (!emit.isDone) {
        emit(CreateLibraryError('Unexpected error: ${e.toString()}'));
      }
    }
  }

  void _onRemoveFolderFromLibrary(
      RemoveFolderFromLibrary event, Emitter<CreateLibraryState> emit) {
    final currentState = state;
    if (currentState is CreateLibraryLoaded) {
      final updatedSelectedFolders =
          List<Folder>.from(currentState.selectedFolders)
            ..removeWhere((folder) => folder.path == event.folder.path);
      emit(currentState.copyWith(selectedFolders: updatedSelectedFolders));
    }
  }
}

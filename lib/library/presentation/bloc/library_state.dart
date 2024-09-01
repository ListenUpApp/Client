part of 'library_bloc.dart';

sealed class LibraryState {
  final List<Library> availableLibraries;
  final Library? currentLibrary;

  const LibraryState({
    required this.availableLibraries,
    this.currentLibrary,
  });
}

final class LibraryInitial extends LibraryState {
  const LibraryInitial() : super(availableLibraries: const []);
}

final class LibraryLoading extends LibraryState {
  const LibraryLoading() : super(availableLibraries: const []);
}

final class LibraryLoaded extends LibraryState {
  const LibraryLoaded({
    required super.availableLibraries,
    super.currentLibrary,
  });
}

final class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message) : super(availableLibraries: const []);
}

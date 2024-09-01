part of 'library_bloc.dart';

@immutable
sealed class LibraryEvent {}

final class LoadLibraries extends LibraryEvent {}

final class SetCurrentLibrary extends LibraryEvent {
  final String libraryId;
  SetCurrentLibrary(this.libraryId);
}

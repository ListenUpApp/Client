part of 'create_library_bloc.dart';

@immutable
sealed class CreateLibraryEvent extends Equatable {
  const CreateLibraryEvent();

  @override
  List<Object> get props => [];
}

final class CreateLibrary extends CreateLibraryEvent {
  final String name;
  final List<Folder> folders;

  const CreateLibrary(this.name, this.folders);
}

final class UpdateLibraryName extends CreateLibraryEvent {
  final String name;
  const UpdateLibraryName(this.name);

  @override
  List<Object> get props => [name];
}

final class LoadDirectories extends CreateLibraryEvent {
  final String path;
  final int level;
  const LoadDirectories(this.path, this.level);

  @override
  List<Object> get props => [path, level];
}

final class NavigateBack extends CreateLibraryEvent {}

final class AddFolderToLibrary extends CreateLibraryEvent {
  final Folder folder;
  const AddFolderToLibrary(this.folder);

  @override
  List<Object> get props => [folder];
}

final class RemoveFolderFromLibrary extends CreateLibraryEvent {
  final Folder folder;
  const RemoveFolderFromLibrary(this.folder);

  @override
  List<Object> get props => [folder];
}

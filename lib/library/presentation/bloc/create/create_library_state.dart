part of 'create_library_bloc.dart';

@immutable
sealed class CreateLibraryState extends Equatable {
  const CreateLibraryState();

  @override
  List<Object> get props => [];
}

class CreateLibraryInitial extends CreateLibraryState {
  const CreateLibraryInitial();
}

class CreateLibraryLoading extends CreateLibraryState {
  const CreateLibraryLoading();
}

class CreateLibrarySuccess extends CreateLibraryState {
  const CreateLibrarySuccess();
}

class CreateLibraryLoaded extends CreateLibraryState {
  final String name;
  final List<Folder> currentFolders;
  final List<String> pathHistory;
  final int currentLevel;
  final List<Folder> selectedFolders;

  const CreateLibraryLoaded({
    required this.name,
    required this.currentFolders,
    required this.pathHistory,
    required this.currentLevel,
    required this.selectedFolders,
  });

  @override
  List<Object> get props =>
      [name, currentFolders, pathHistory, currentLevel, selectedFolders];

  CreateLibraryLoaded copyWith({
    String? name,
    List<Folder>? currentFolders,
    List<String>? pathHistory,
    int? currentLevel,
    List<Folder>? selectedFolders,
  }) {
    return CreateLibraryLoaded(
      name: name ?? this.name,
      currentFolders: currentFolders ?? this.currentFolders,
      pathHistory: pathHistory ?? this.pathHistory,
      currentLevel: currentLevel ?? this.currentLevel,
      selectedFolders: selectedFolders ?? this.selectedFolders,
    );
  }
}

class CreateLibraryError extends CreateLibraryState {
  final String message;

  const CreateLibraryError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:listenup/core/domain/types.dart';
import 'package:listenup/core/domain/usecases.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/library_repository.dart';

class CreateLibrary implements UsecaseWithParams<void, CreateLibraryRequest> {
  final ILibraryRepository _repository;

  CreateLibrary(this._repository);

  @override
  ResultFuture<void> call(CreateLibraryRequest params) =>
      _repository.createLibrary(request: params);
}

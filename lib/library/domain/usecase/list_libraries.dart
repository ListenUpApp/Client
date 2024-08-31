import 'package:listenup/core/domain/types.dart';
import 'package:listenup/core/domain/usecases.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/library_repository.dart';

class ListLibrariesUsecase
    implements UsecaseWithParams<void, ListLibrariesRequest> {
  final ILibraryRepository _repository;

  ListLibrariesUsecase(this._repository);

  @override
  ResultFuture<void> call(ListLibrariesRequest params) =>
      _repository.listLibraries(request: params);
}

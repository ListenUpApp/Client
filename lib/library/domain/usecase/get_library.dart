import 'package:listenup/core/domain/types.dart';
import 'package:listenup/core/domain/usecases.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/library_repository.dart';

class GetLibraryUsecase implements UsecaseWithParams<void, GetLibraryRequest> {
  final ILibraryRepository _repository;

  GetLibraryUsecase(this._repository);

  @override
  ResultFuture<void> call(GetLibraryRequest params) =>
      _repository.getLibrary(request: params);
}

import 'package:listenup/core/domain/types.dart';
import 'package:listenup/core/domain/usecases.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/library/domain/library_repository.dart';

class GetFolderUsecase implements UsecaseWithParams<void, GetFolderRequest> {
  final ILibraryRepository _repository;

  GetFolderUsecase(this._repository);

  @override
  ResultFuture<GetFolderResponse> call(GetFolderRequest params) =>
      _repository.getFolder(request: params);
}

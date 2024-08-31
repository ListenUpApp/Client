import 'package:listenup/core/domain/types.dart';
import 'package:listenup/core/domain/usecases.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/library_repository.dart';

class GetLibrariesForUser
    implements UsecaseWithParams<void, GetLibrariesForUserRequest> {
  final ILibraryRepository _repository;

  GetLibrariesForUser(this._repository);

  @override
  ResultFuture<void> call(GetLibrariesForUserRequest params) =>
      _repository.getLibrariesForUser(request: params);
}

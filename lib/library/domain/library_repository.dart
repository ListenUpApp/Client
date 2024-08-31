import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';

import '../../core/domain/types.dart';

abstract interface class ILibraryRepository {
  ResultFuture<GetLibraryResponse> getLibrary(
      {required GetLibraryRequest request});
  ResultFuture<GetLibrariesForUserResponse> getLibrariesForUser(
      {required GetLibrariesForUserRequest request});
  ResultFuture<ListLibrariesResponse> listLibraries(
      {required ListLibrariesRequest request});
  ResultFuture<CreateLibraryResponse> createLibrary(
      {required CreateLibraryRequest request});
  ResultFuture<AddDirectoryToLibraryResponse> addDirectoryToLibrary(
      {required AddDirectoryToLibraryRequest request});
  ResultFuture<GetFolderResponse> getFolder(
      {required GetFolderRequest request});
}

import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';

abstract interface class ILibraryRemoteDatasource {
  Future<GetLibraryResponse> getLibrary(GetLibraryRequest request);
  Future<GetLibrariesForUserResponse> getLibrariesForUser(
      GetLibrariesForUserRequest request);
  Future<ListLibrariesResponse> listLibraries(ListLibrariesRequest request);
  Future<CreateLibraryResponse> createLibrary(CreateLibraryRequest request);
  Future<AddDirectoryToLibraryResponse> addDirectoryToLibrary(
      AddDirectoryToLibraryRequest request);
  Future<GetFolderResponse> getFolder(GetFolderRequest request);
}

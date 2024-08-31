import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/datasource/library_remote_datasource.dart';

import '../../core/domain/network/client_factory.dart';

class LibraryRemoteDatasource implements ILibraryRemoteDatasource {
  final IGrpcClientFactory _clientFactory;

  LibraryRemoteDatasource(this._clientFactory);
  @override
  Future<AddDirectoryToLibraryResponse> addDirectoryToLibrary(
      AddDirectoryToLibraryRequest request) async {
    final client = _clientFactory.getLibraryServiceClient();
    final response = await client.addDirectoryToLibrary(request);
    return response;
  }

  @override
  Future<CreateLibraryResponse> createLibrary(
      CreateLibraryRequest request) async {
    final client = _clientFactory.getLibraryServiceClient();
    final response = await client.createLibrary(request);
    return response;
  }

  @override
  Future<GetFolderResponse> getFolder(GetFolderRequest request) async {
    final client = _clientFactory.getFolderServiceClient();
    final response = await client.getFolder(request);
    return response;
  }

  @override
  Future<GetLibrariesForUserResponse> getLibrariesForUser(
      GetLibrariesForUserRequest request) async {
    final client = _clientFactory.getLibraryServiceClient();
    final response = await client.getLibrariesForUser(request);
    return response;
  }

  @override
  Future<GetLibraryResponse> getLibrary(GetLibraryRequest request) async {
    final client = _clientFactory.getLibraryServiceClient();
    final response = await client.getLibrary(request);
    return response;
  }

  @override
  Future<ListLibrariesResponse> listLibraries(
      ListLibrariesRequest request) async {
    final client = _clientFactory.getLibraryServiceClient();
    final response = await client.listLibraries(request);
    return response;
  }
}

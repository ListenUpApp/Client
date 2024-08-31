import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:listenup/core/domain/errors/failure.dart';
import 'package:listenup/core/domain/types.dart';
import 'package:listenup/generated/listenup/folder/v1/folder.pb.dart';
import 'package:listenup/generated/listenup/library/v1/library.pb.dart';
import 'package:listenup/library/domain/datasource/library_remote_datasource.dart';
import 'package:listenup/library/domain/library_repository.dart';

class LibraryRepository implements ILibraryRepository {
  final ILibraryRemoteDatasource _libraryRemoteDatasource;

  LibraryRepository(this._libraryRemoteDatasource);

  @override
  ResultFuture<AddDirectoryToLibraryResponse> addDirectoryToLibrary(
      {required AddDirectoryToLibraryRequest request}) async {
    try {
      final response =
          await _libraryRemoteDatasource.addDirectoryToLibrary(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<CreateLibraryResponse> createLibrary(
      {required CreateLibraryRequest request}) async {
    try {
      final response = await _libraryRemoteDatasource.createLibrary(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<GetFolderResponse> getFolder(
      {required GetFolderRequest request}) async {
    try {
      final response = await _libraryRemoteDatasource.getFolder(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<GetLibrariesForUserResponse> getLibrariesForUser(
      {required GetLibrariesForUserRequest request}) async {
    try {
      final response =
          await _libraryRemoteDatasource.getLibrariesForUser(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<GetLibraryResponse> getLibrary(
      {required GetLibraryRequest request}) async {
    try {
      final response = await _libraryRemoteDatasource.getLibrary(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  ResultFuture<ListLibrariesResponse> listLibraries(
      {required ListLibrariesRequest request}) async {
    try {
      final response = await _libraryRemoteDatasource.listLibraries(request);
      return Right(response);
    } on GrpcError catch (e) {
      return Left(GrpcFailure(
          code: e.code, message: e.message ?? 'Unknown gRPC error'));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}

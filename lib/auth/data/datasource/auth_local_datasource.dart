import 'package:listenup/auth/data/token_storage.dart';
import 'package:listenup/auth/domain/datasource/auth_local_datasource.dart';

class AuthLocalDatasource implements IAuthLocalDataSource {
  final TokenStorage _tokenStorage;

  AuthLocalDatasource(this._tokenStorage);
  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getToken();
    return token?.isNotEmpty ?? false;
  }
}

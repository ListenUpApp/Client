import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listenup/auth/domain/token_storage.dart';

class TokenStorage implements ITokenStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  @override
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}

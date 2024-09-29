import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listenup/auth/data/token_storage.dart';
import 'package:listenup/auth/domain/datasource/auth_local_datasource.dart';

import '../../../generated/listenup/user/v1/user.pb.dart';

class AuthLocalDatasource implements IAuthLocalDataSource {
  final TokenStorage _tokenStorage;
  final FlutterSecureStorage _secureStorage;

  AuthLocalDatasource(this._tokenStorage, this._secureStorage);
  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getToken();
    return token?.isNotEmpty ?? false;
  }

  @override
  Future<void> saveUserCredentials(User user) async {
    final jsonMap = user.toProto3Json() as Map<String, dynamic>;
    final userJson = json.encode(jsonMap);
    await _secureStorage.write(key: 'user', value: userJson);
  }

  @override
  Future<void> saveToken(String token) async {
    return await _secureStorage.write(key: 'auth_token', value: token);
  }

  @override
  Future<String?> readToken() async {
    final token = await _secureStorage.read(key: 'auth_token');
    if (token != '') {
      return token;
    }
    return null;
  }

  @override
  Future<User?> loadUserCredentials() async {
    final userJson = await _secureStorage.read(key: 'user');
    if (userJson != null) {
      // Parse JSON string
      final jsonMap = json.decode(userJson) as Map<String, dynamic>;

      final user = User();
      user.mergeFromProto3Json(jsonMap);
      return user;
    } else {
      return null;
    }
  }
}

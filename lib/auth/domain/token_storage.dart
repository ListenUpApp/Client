abstract interface class ITokenStorage {
  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> deleteToken();
}

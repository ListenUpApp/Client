import '../../../generated/listenup/user/v1/user.pb.dart';

abstract interface class IAuthLocalDataSource {
  Future<bool> isAuthenticated();
  Future<void> saveUserCredentials(User user);
  Future<User?> loadUserCredentials();
  Future<void> saveToken(String token);
  Future<String?> readToken();
}

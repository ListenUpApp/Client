import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/config/config_service.dart';

class ConfigService extends ChangeNotifier implements IConfigService {
  static const String _grpcServerUrlKey = 'grpc_server_url';
  String? _grpcServerUrl;
  bool _isLoaded = false;
  final FlutterSecureStorage _secureStorage;

  ConfigService(this._secureStorage);

  Future<void> init() async {
    await _loadGrpcServerUrl();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _loadGrpcServerUrl() async {
    _grpcServerUrl = await _secureStorage.read(key: _grpcServerUrlKey);
    notifyListeners();
  }

  @override
  String? get grpcServerUrl => _grpcServerUrl;

  @override
  Future<String?> getGrpcServerUrl() async {
    if (!_isLoaded) {
      await init();
    }
    return _grpcServerUrl;
  }

  @override
  Future<void> setGrpcServerUrl(String url) async {
    _grpcServerUrl = url;
    await _secureStorage.write(key: _grpcServerUrlKey, value: url);
    _isLoaded = true;
    notifyListeners();
  }

  @override
  Future<void> clearGrpcServerUrl() async {
    _grpcServerUrl = null;
    await _secureStorage.delete(key: _grpcServerUrlKey);
    notifyListeners();
  }
}

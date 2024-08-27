import 'package:flutter/foundation.dart';

import '../../domain/config/config_service.dart';

class ConfigService extends ChangeNotifier implements IConfigService {
  String? _grpcServerUrl;

  @override
  String? get grpcServerUrl => _grpcServerUrl;

  @override
  void setGrpcServerUrl(String url) {
    _grpcServerUrl = url;
    notifyListeners();
  }
}

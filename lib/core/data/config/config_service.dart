import 'package:flutter/foundation.dart';

import '../../domain/config/config_service.dart';

class ConfigServiceImplementation extends ChangeNotifier
    implements IConfigService {
  String? _grpcServerUrl;

  @override
  String? get grpcServerUrl => _grpcServerUrl;

  @override
  void setGrpcServerUrl(String url) {
    _grpcServerUrl = url;
    notifyListeners();
  }
}

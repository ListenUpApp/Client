abstract interface class IConfigService {
  String? _grpcServerUrl;

  String? get grpcServerUrl => _grpcServerUrl;
  void setGrpcServerUrl(String url);
}

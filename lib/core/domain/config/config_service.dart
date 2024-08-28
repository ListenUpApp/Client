abstract interface class IConfigService {
  String? _grpcServerUrl;

  String? get grpcServerUrl => _grpcServerUrl;
  void setGrpcServerUrl(String url);

  Future<void> clearGrpcServerUrl();

  Future<String?> getGrpcServerUrl();
}

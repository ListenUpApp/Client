import 'dart:async';

import 'package:grpc/grpc.dart';
import 'package:listenup/auth/domain/datasource/auth_local_datasource.dart';

class AuthInterceptor extends ClientInterceptor {
  final IAuthLocalDataSource _localDataSource;

  AuthInterceptor(this._localDataSource);

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    return invoker(method, request, _injectToken(options));
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    return invoker(method, requests, _injectToken(options));
  }

  CallOptions _injectToken(CallOptions options) {
    return options.mergedWith(CallOptions(providers: [
      (metadata, uri) async {
        final token = await _localDataSource.readToken();
        if (token != null) {
          metadata['authorization'] = 'Bearer $token';
        }
      }
    ]));
  }
}

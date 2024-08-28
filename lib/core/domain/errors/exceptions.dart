import 'package:equatable/equatable.dart';

class GrpcException extends Equatable implements Exception {
  final String message;
  final int errorCode;

  const GrpcException({required this.message, required this.errorCode});

  @override
  List<Object?> get props => [message, errorCode];
}

class InternalAppException implements Exception {
  final String message;

  InternalAppException(this.message);

  @override
  String toString() => 'InternalAppException: $message';
}

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class GrpcFailure extends Failure {
  final int code;
  final String message;

  GrpcFailure({required this.code, required this.message});

  @override
  List<Object> get props => [code, message];

  @override
  String toString() => 'GrpcFailure(code: $code, message: $message)';
}

class UnexpectedFailure extends Failure {
  final String? message;

  UnexpectedFailure([this.message]);

  @override
  List<Object> get props => [message ?? ''];

  @override
  String toString() =>
      'UnexpectedFailure(${message ?? 'An unexpected error occurred'})';
}

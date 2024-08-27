import 'package:equatable/equatable.dart';

sealed class UrlState extends Equatable {
  const UrlState();

  @override
  List<Object> get props => [];
}

class UrlInitial extends UrlState {
  final String url;

  const UrlInitial(this.url);

  @override
  List<Object> get props => [url];
}

class UrlLoading extends UrlState {
  final String url;

  const UrlLoading(this.url);

  @override
  List<Object> get props => [url];
}

class UrlLoadSuccess extends UrlState {
  final String url;

  const UrlLoadSuccess(this.url);

  @override
  List<Object> get props => [url];
}

class UrlLoadFailure extends UrlState {
  final String url;
  final String error;

  const UrlLoadFailure(this.url, this.error);

  @override
  List<Object> get props => [url, error];
}

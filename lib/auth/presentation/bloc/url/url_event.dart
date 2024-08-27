part of 'url_bloc.dart';

abstract class UrlEvent extends Equatable {
  const UrlEvent();

  @override
  List<Object> get props => [];
}

class UrlPingSuccess extends UrlEvent {}

class SubmitButtonPressed extends UrlEvent {
  final String url;
  const SubmitButtonPressed(this.url);
  @override
  List<Object> get props => [url];
}

class UrlErrorOccurred extends UrlEvent {
  final String message;
  const UrlErrorOccurred(this.message);

  @override
  List<Object> get props => [message];
}

class UrlChanged extends UrlEvent {
  final String url;
  const UrlChanged(this.url);

  @override
  List<Object> get props => [url];
}

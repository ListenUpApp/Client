part of 'url_bloc.dart';

abstract class UrlEvent extends Equatable {
  const UrlEvent();

  @override
  List<Object> get props => [];
}

class UrlChanged extends UrlEvent {
  final String url;

  const UrlChanged(this.url);

  @override
  List<Object> get props => [url];
}

class SubmitButtonPressed extends UrlEvent {
  final String url;

  const SubmitButtonPressed(this.url);

  @override
  List<Object> get props => [url];
}

class LoadSavedUrl extends UrlEvent {}

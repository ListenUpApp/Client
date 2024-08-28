part of 'url_bloc.dart';

sealed class UrlEvent {
  const UrlEvent();
}

final class UrlChanged extends UrlEvent {
  final String url;
  const UrlChanged(this.url);
}

final class SubmitButtonPressed extends UrlEvent {
  final String url;
  const SubmitButtonPressed(this.url);
}

final class LoadSavedUrl extends UrlEvent {
  const LoadSavedUrl();
}

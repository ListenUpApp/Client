part of 'url_bloc.dart';

abstract class UrlEvent extends Equatable {
  const UrlEvent();

  @override
  List<Object> get props => [];
}

class UrlPingSuccess extends UrlEvent {}

class UrlErrorOccurred extends UrlEvent {
  final String message;
  const UrlErrorOccurred(this.message);

  @override
  List<Object> get props => [message];
}

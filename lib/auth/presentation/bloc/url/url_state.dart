part of 'url_bloc.dart';

@immutable
class UrlState extends Equatable {
  final String url;
  final bool isPinging;
  final bool canSubmit;

  const UrlState({
    this.url = '',
    this.isPinging = false,
    this.canSubmit = false,
  });

  UrlState copyWith({
    String? url,
    bool? isPinging,
    bool? canSubmit,
  }) {
    return UrlState(
      url: url ?? this.url,
      isPinging: isPinging ?? this.isPinging,
      canSubmit: canSubmit ?? this.canSubmit,
    );
  }

  @override
  List<Object> get props => [url, isPinging, canSubmit];
}

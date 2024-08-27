part of 'url_bloc.dart';

@immutable
class UrlState extends Equatable {
  final String url;
  final bool isPinging;
  final bool canSubmit;
  final bool pingSuccess;
  final String? error;

  const UrlState({
    this.url = '',
    this.isPinging = false,
    this.canSubmit = false,
    this.pingSuccess = false,
    this.error,
  });

  UrlState copyWith({
    String? url,
    bool? isPinging,
    bool? canSubmit,
    bool? pingSuccess,
    String? error,
  }) {
    return UrlState(
      url: url ?? this.url,
      isPinging: isPinging ?? this.isPinging,
      canSubmit: canSubmit ?? this.canSubmit,
      pingSuccess: pingSuccess ?? this.pingSuccess,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [url, isPinging, canSubmit];
}

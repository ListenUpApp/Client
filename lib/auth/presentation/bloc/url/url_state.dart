sealed class UrlState {
  final String url;
  const UrlState(this.url);
}

final class UrlInitial extends UrlState {
  const UrlInitial(super.url);
}

final class UrlLoading extends UrlState {
  const UrlLoading(super.url);
}

final class UrlLoadSuccess extends UrlState {
  const UrlLoadSuccess(super.url);
}

final class UrlLoadFailure extends UrlState {
  final String error;
  const UrlLoadFailure(super.url, this.error);
}

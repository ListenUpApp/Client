import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'url_event.dart';
part 'url_state.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(const UrlState()) {
    on<UrlPingSuccess>(_onPingSuccess);
    on<UrlErrorOccurred>(_onErrorOccurred);
  }

  void _onPingSuccess(UrlPingSuccess event, Emitter<UrlState> emit) {
    emit(state.copyWith(isPinging: false, canSubmit: true));
  }

  void _onErrorOccurred(UrlErrorOccurred event, Emitter<UrlState> emit) {
    emit(state.copyWith(isPinging: false, canSubmit: false));
  }

  void onUrlChange(String url, Emitter<UrlState> emit) {
    emit(state.copyWith(url: url));
  }

  void onSubmitClick(Emitter<UrlState> emit) {
    emit(state.copyWith(isPinging: true));
  }
}

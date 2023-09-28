part of 'history_bloc.dart';

@immutable
abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();

  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();

  List<Object>? get props => null;
}

class HistoryMoreLoading extends HistoryState {
  const HistoryMoreLoading();

  List<Object>? get props => null;
}

class HistoryLoaded extends HistoryState {
  final List<Data> list;
  final int? count;
  final int? limit;
  const HistoryLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);
  List<Object> get props => [message];
}

class HistoryNoAuth extends HistoryState {
  const HistoryNoAuth();
  List<Object> get props => [];
}

class HistoryUpdateApp extends HistoryState {
  const HistoryUpdateApp();
  List<Object> get props => [];
}

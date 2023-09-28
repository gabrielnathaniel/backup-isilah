part of 'rank_today_bloc.dart';

@immutable
sealed class RankTodayState {
  const RankTodayState();
}

final class RankTodayInitial extends RankTodayState {
  const RankTodayInitial();

  List<Object> get props => [];
}

class RankTodayLoading extends RankTodayState {
  const RankTodayLoading();

  List<Object>? get props => null;
}

class RankTodayMoreLoading extends RankTodayState {
  const RankTodayMoreLoading();

  List<Object>? get props => null;
}

class RankTodayLoaded extends RankTodayState {
  final List<DataRanks> list;
  final int? count;
  final int? limit;
  const RankTodayLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class RankTodayError extends RankTodayState {
  final String message;

  const RankTodayError(this.message);
  List<Object> get props => [message];
}

class RankTodayNoAuth extends RankTodayState {
  const RankTodayNoAuth();
  List<Object> get props => [];
}

class RankTodayUpdateApp extends RankTodayState {
  const RankTodayUpdateApp();
  List<Object> get props => [];
}

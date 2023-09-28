part of 'rank_weekly_bloc.dart';

@immutable
sealed class RankWeeklyState {
  const RankWeeklyState();
}

final class RankWeeklyInitial extends RankWeeklyState {
  const RankWeeklyInitial();

  List<Object> get props => [];
}

class RankWeeklyLoading extends RankWeeklyState {
  const RankWeeklyLoading();

  List<Object>? get props => null;
}

class RankWeeklyMoreLoading extends RankWeeklyState {
  const RankWeeklyMoreLoading();

  List<Object>? get props => null;
}

class RankWeeklyLoaded extends RankWeeklyState {
  final List<DataRanks> list;
  final int? count;
  final int? limit;
  const RankWeeklyLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class RankWeeklyError extends RankWeeklyState {
  final String message;

  const RankWeeklyError(this.message);
  List<Object> get props => [message];
}

class RankWeeklyNoAuth extends RankWeeklyState {
  const RankWeeklyNoAuth();
  List<Object> get props => [];
}

class RankWeeklyUpdateApp extends RankWeeklyState {
  const RankWeeklyUpdateApp();
  List<Object> get props => [];
}

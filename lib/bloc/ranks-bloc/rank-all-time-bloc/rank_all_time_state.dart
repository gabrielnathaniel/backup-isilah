part of 'rank_all_time_bloc.dart';

@immutable
sealed class RankAllTimeState {
  const RankAllTimeState();
}

final class RankAllTimeInitial extends RankAllTimeState {
  const RankAllTimeInitial();

  List<Object> get props => [];
}

class RankAllTimeLoading extends RankAllTimeState {
  const RankAllTimeLoading();

  List<Object>? get props => null;
}

class RankAllTimeMoreLoading extends RankAllTimeState {
  const RankAllTimeMoreLoading();

  List<Object>? get props => null;
}

class RankAllTimeLoaded extends RankAllTimeState {
  final List<DataRanks> list;
  final int? count;
  final int? limit;
  const RankAllTimeLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class RankAllTimeError extends RankAllTimeState {
  final String message;

  const RankAllTimeError(this.message);
  List<Object> get props => [message];
}

class RankAllTimeNoAuth extends RankAllTimeState {
  const RankAllTimeNoAuth();
  List<Object> get props => [];
}

class RankAllTimeUpdateApp extends RankAllTimeState {
  const RankAllTimeUpdateApp();
  List<Object> get props => [];
}

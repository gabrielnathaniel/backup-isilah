part of 'rank_monthly_bloc.dart';

@immutable
sealed class RankMonthlyState {
  const RankMonthlyState();
}

final class RankMonthlyInitial extends RankMonthlyState {
  const RankMonthlyInitial();

  List<Object> get props => [];
}

class RankMonthlyLoading extends RankMonthlyState {
  const RankMonthlyLoading();

  List<Object>? get props => null;
}

class RankMonthlyMoreLoading extends RankMonthlyState {
  const RankMonthlyMoreLoading();

  List<Object>? get props => null;
}

class RankMonthlyLoaded extends RankMonthlyState {
  final List<DataRanks> list;
  final int? count;
  final int? limit;
  const RankMonthlyLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class RankMonthlyError extends RankMonthlyState {
  final String message;

  const RankMonthlyError(this.message);
  List<Object> get props => [message];
}

class RankMonthlyNoAuth extends RankMonthlyState {
  const RankMonthlyNoAuth();
  List<Object> get props => [];
}

class RankMonthlyUpdateApp extends RankMonthlyState {
  const RankMonthlyUpdateApp();
  List<Object> get props => [];
}

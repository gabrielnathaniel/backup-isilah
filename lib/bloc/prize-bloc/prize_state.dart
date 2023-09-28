part of 'prize_bloc.dart';

@immutable
abstract class PrizeState {
  const PrizeState();
}

class PrizeInitial extends PrizeState {
  const PrizeInitial();

  List<Object> get props => [];
}

// Fetch Prize
class GetPrizeLoading extends PrizeState {
  const GetPrizeLoading();

  List<Object>? get props => null;
}

class GetPrizeLoaded extends PrizeState {
  final PrizeModel prizeModel;
  const GetPrizeLoaded(this.prizeModel);

  List<Object?> get props => [prizeModel];
}

class GetPrizeError extends PrizeState {
  final String message;

  const GetPrizeError(this.message);
  List<Object> get props => [message];
}

// Histories Claim Prize
class HistoriesClaimLoading extends PrizeState {
  const HistoriesClaimLoading();

  List<Object>? get props => null;
}

class HistoriesClaimMoreLoading extends PrizeState {
  const HistoriesClaimMoreLoading();

  List<Object>? get props => null;
}

class HistoriesClaimLoaded extends PrizeState {
  final List<ClaimFinishData> list;
  final int? count;
  final int? limit;
  const HistoriesClaimLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class HistoriesClaimError extends PrizeState {
  final String message;

  const HistoriesClaimError(this.message);
  List<Object> get props => [message];
}

// Prizes Next Level
class PrizeNextLevelLoading extends PrizeState {
  const PrizeNextLevelLoading();

  List<Object>? get props => null;
}

class PrizeNextLevelLoaded extends PrizeState {
  final PrizeModel prizeModel;
  final int? experiencePercentage;
  final int? experienceUser;
  final String? levelUser;
  const PrizeNextLevelLoaded(this.prizeModel, this.experiencePercentage,
      this.experienceUser, this.levelUser);

  List<Object?> get props => [prizeModel];
}

class PrizeNextLevelError extends PrizeState {
  final String message;

  const PrizeNextLevelError(this.message);
  List<Object> get props => [message];
}

part of 'leaderboard_treasure_chest_bloc.dart';

@immutable
abstract class LeaderboardTreasureChestState {
  const LeaderboardTreasureChestState();
}

class LeaderboardTreasureChestInitial extends LeaderboardTreasureChestState {
  const LeaderboardTreasureChestInitial();

  List<Object> get props => [];
}

class LeaderboardTreasureChestLoading extends LeaderboardTreasureChestState {
  const LeaderboardTreasureChestLoading();

  List<Object>? get props => null;
}

class LeaderboardTreasureChestMoreLoading
    extends LeaderboardTreasureChestState {
  const LeaderboardTreasureChestMoreLoading();

  List<Object>? get props => null;
}

class LeaderboardTreasureChestLoaded extends LeaderboardTreasureChestState {
  final List<LeaderboardTreasureChestList> list;
  final int? count;
  final int? limit;
  const LeaderboardTreasureChestLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class LeaderboardTreasureChestError extends LeaderboardTreasureChestState {
  final String message;

  const LeaderboardTreasureChestError(this.message);
  List<Object> get props => [message];
}

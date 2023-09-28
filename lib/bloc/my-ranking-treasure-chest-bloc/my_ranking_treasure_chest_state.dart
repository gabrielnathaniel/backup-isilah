part of 'my_ranking_treasure_chest_bloc.dart';

@immutable
abstract class MyRankingTreasureChestState {
  const MyRankingTreasureChestState();
}

class MyRankingTreasureChestInitial extends MyRankingTreasureChestState {
  const MyRankingTreasureChestInitial();

  List<Object> get props => [];
}

class MyRankingTreasureChestLoading extends MyRankingTreasureChestState {
  const MyRankingTreasureChestLoading();

  List<Object>? get props => null;
}

class MyRankingTreasureChestLoaded extends MyRankingTreasureChestState {
  final MyRankingTreaseureChestModel? myRankingTreaseureChestModel;

  const MyRankingTreasureChestLoaded(this.myRankingTreaseureChestModel);

  List<Object?> get props => [myRankingTreaseureChestModel];
}

class MyRankingTreasureChestError extends MyRankingTreasureChestState {
  final String message;

  const MyRankingTreasureChestError(this.message);
  List<Object> get props => [message];
}

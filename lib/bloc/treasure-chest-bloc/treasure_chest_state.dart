part of 'treasure_chest_bloc.dart';

@immutable
abstract class TreasureChestState {
  const TreasureChestState();
}

class TreasureChestInitial extends TreasureChestState {
  const TreasureChestInitial();

  List<Object> get props => [];
}

// Play TreasureChest
class PlayTreasureChestLoading extends TreasureChestState {
  const PlayTreasureChestLoading();

  List<Object>? get props => null;
}

class PlayTreasureChestLoaded extends TreasureChestState {
  final TreasureChestModel treasureChestModel;
  const PlayTreasureChestLoaded(this.treasureChestModel);

  List<Object?> get props => [treasureChestModel];
}

class PlayTreasureChestError extends TreasureChestState {
  final String message;

  const PlayTreasureChestError(this.message);
  List<Object> get props => [message];
}

class PlayTreasureChestNoAuth extends TreasureChestState {
  const PlayTreasureChestNoAuth();
  List<Object> get props => [];
}

class PlayTreasureChestUpdateApp extends TreasureChestState {
  const PlayTreasureChestUpdateApp();
  List<Object> get props => [];
}

// Result TreasureChest
class ResultTreasureChestLoading extends TreasureChestState {
  const ResultTreasureChestLoading();

  List<Object>? get props => null;
}

class ResultTreasureChestLoaded extends TreasureChestState {
  final ResultQuizModel resultQuizModel;
  const ResultTreasureChestLoaded(this.resultQuizModel);

  List<Object?> get props => [resultQuizModel];
}

class ResultTreasureChestError extends TreasureChestState {
  final String message;

  const ResultTreasureChestError(this.message);
  List<Object> get props => [message];
}

class ResultTreasureChestNoAuth extends TreasureChestState {
  const ResultTreasureChestNoAuth();
  List<Object> get props => [];
}

class ResultTreasureChestUpdateApp extends TreasureChestState {
  const ResultTreasureChestUpdateApp();
  List<Object> get props => [];
}

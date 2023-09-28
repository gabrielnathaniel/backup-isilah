part of 'treasure_chest_list_bloc.dart';

@immutable
abstract class TreasureChestListState {
  const TreasureChestListState();
}

class TreasureChestListInitial extends TreasureChestListState {
  const TreasureChestListInitial();

  List<Object> get props => [];
}

class TreasureChestListLoading extends TreasureChestListState {
  const TreasureChestListLoading();

  List<Object>? get props => null;
}

class TreasureChestListLoaded extends TreasureChestListState {
  final TreasureChestListModel treasureChestListModel;
  const TreasureChestListLoaded(this.treasureChestListModel);

  List<Object> get props => [treasureChestListModel];
}

class TreasureChestListError extends TreasureChestListState {
  final String message;
  const TreasureChestListError(this.message);

  List<Object> get props => [message];
}

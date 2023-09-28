part of 'treasure_chest_list_bloc.dart';

@immutable
abstract class TreasureChestListEvent {
  const TreasureChestListEvent();
}

class GetTreasureChestList extends TreasureChestListEvent {
  final CHttp? http;

  const GetTreasureChestList({this.http});
}

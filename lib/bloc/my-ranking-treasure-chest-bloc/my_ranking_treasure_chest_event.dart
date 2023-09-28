part of 'my_ranking_treasure_chest_bloc.dart';

@immutable
abstract class MyRankingTreasureChestEvent {
  const MyRankingTreasureChestEvent();
}

class GetMyRankingTreasureChest extends MyRankingTreasureChestEvent {
  final CHttp? http;
  final int? eventId;

  const GetMyRankingTreasureChest({this.http, this.eventId});
}

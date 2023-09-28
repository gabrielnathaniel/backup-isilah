part of 'leaderboard_treasure_chest_bloc.dart';

@immutable
abstract class LeaderboardTreasureChestEvent {
  const LeaderboardTreasureChestEvent();
}

class GetLeaderboardTreasureChest extends LeaderboardTreasureChestEvent {
  final CHttp? http;
  final int? eventId;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetLeaderboardTreasureChest(
      {this.http, this.eventId, this.statusLoad, this.isRefresh, this.page});
}

class GetMoreLeaderboardTreasureChest extends LeaderboardTreasureChestEvent {
  final CHttp? http;
  final int? eventId;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreLeaderboardTreasureChest(
      {this.http, this.eventId, this.statusLoad, this.isRefresh, this.page});
}

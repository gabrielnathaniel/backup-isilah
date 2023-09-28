part of 'rank_today_bloc.dart';

@immutable
sealed class RankTodayEvent {
  const RankTodayEvent();
}

class GetRankToday extends RankTodayEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetRankToday({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetMoreRankToday extends RankTodayEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreRankToday(
      {this.http, this.statusLoad, this.page, this.isRefresh});
}

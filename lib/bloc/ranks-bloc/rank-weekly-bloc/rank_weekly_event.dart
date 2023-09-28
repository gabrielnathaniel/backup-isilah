part of 'rank_weekly_bloc.dart';

@immutable
sealed class RankWeeklyEvent {
  const RankWeeklyEvent();
}

class GetRankWeekly extends RankWeeklyEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetRankWeekly({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetMoreRankWeekly extends RankWeeklyEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreRankWeekly(
      {this.http, this.statusLoad, this.page, this.isRefresh});
}

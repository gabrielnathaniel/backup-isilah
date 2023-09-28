part of 'rank_all_time_bloc.dart';

@immutable
sealed class RankAllTimeEvent {
  const RankAllTimeEvent();
}

class GetRankAllTime extends RankAllTimeEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetRankAllTime({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetMoreRankAllTime extends RankAllTimeEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreRankAllTime(
      {this.http, this.statusLoad, this.page, this.isRefresh});
}

part of 'rank_monthly_bloc.dart';

@immutable
sealed class RankMonthlyEvent {
  const RankMonthlyEvent();
}

class GetRankMonthly extends RankMonthlyEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetRankMonthly({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetMoreRankMonthly extends RankMonthlyEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreRankMonthly(
      {this.http, this.statusLoad, this.page, this.isRefresh});
}

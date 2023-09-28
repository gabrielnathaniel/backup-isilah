part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {
  const HistoryEvent();
}

class GetHistory extends HistoryEvent {
  final CHttp? http;
  final String? startDate;
  final String? endDate;
  final int? page;
  final bool? statusLoad;
  final bool? statusRefresh;
  const GetHistory(
      {this.http,
      this.statusLoad,
      this.statusRefresh,
      this.startDate,
      this.endDate,
      this.page});
}

class GetMoreHistory extends HistoryEvent {
  final CHttp? http;
  final String? startDate;
  final String? endDate;
  final int? page;
  final bool? statusLoad;
  final bool? statusRefresh;
  const GetMoreHistory(
      {this.http,
      this.statusLoad,
      this.statusRefresh,
      this.startDate,
      this.endDate,
      this.page});
}

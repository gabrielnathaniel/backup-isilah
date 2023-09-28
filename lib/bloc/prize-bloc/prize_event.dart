part of 'prize_bloc.dart';

@immutable
abstract class PrizeEvent {
  const PrizeEvent();
}

class GetPrize extends PrizeEvent {
  final CHttp? http;
  final BuildContext? context;

  const GetPrize({this.http, this.context});
}

class GetHistoriesClaim extends PrizeEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final String? search;
  final String? sortBy;
  final String? sort;
  const GetHistoriesClaim(
      {this.http,
      this.statusLoad,
      this.page,
      this.search,
      this.sortBy,
      this.sort});
}

class GetMoreHistoriesClaim extends PrizeEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final String? search;
  final String? sortBy;
  final String? sort;
  const GetMoreHistoriesClaim(
      {this.http,
      this.statusLoad,
      this.page,
      this.search,
      this.sortBy,
      this.sort});
}

/// prizes next level
class GetPrizeNextLevel extends PrizeEvent {
  final CHttp? http;
  final BuildContext? context;

  const GetPrizeNextLevel({this.http, this.context});
}

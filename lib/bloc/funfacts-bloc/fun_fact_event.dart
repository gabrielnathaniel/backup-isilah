part of 'fun_fact_bloc.dart';

@immutable
abstract class FunFactEvent {
  const FunFactEvent();
}

class GetFunFact extends FunFactEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetFunFact({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetMoreFunFact extends FunFactEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  final bool? isRefresh;
  const GetMoreFunFact({this.http, this.statusLoad, this.page, this.isRefresh});
}

class GetDetailFunFact extends FunFactEvent {
  final CHttp? http;
  final int? id;
  const GetDetailFunFact({this.http, this.id});
}

class GetFunFactCaraousel extends FunFactEvent {
  final CHttp? http;
  const GetFunFactCaraousel({this.http});
}

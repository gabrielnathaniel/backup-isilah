part of 'faq_bloc.dart';

@immutable
abstract class FaqEvent {
  const FaqEvent();
}

class GetFaq extends FaqEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetFaq({this.http, this.statusLoad, this.page});
}

class GetMoreFaq extends FaqEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetMoreFaq({this.http, this.statusLoad, this.page});
}

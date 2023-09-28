part of 'referral_user_bloc.dart';

@immutable
abstract class ReferralUserEvent {
  const ReferralUserEvent();
}

class GetReferralUser extends ReferralUserEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetReferralUser({this.http, this.statusLoad, this.page});
}

class GetMoreReferralUser extends ReferralUserEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetMoreReferralUser({this.http, this.statusLoad, this.page});
}

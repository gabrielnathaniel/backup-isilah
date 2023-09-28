part of 'referral_step_bloc.dart';

@immutable
abstract class ReferralStepEvent {
  const ReferralStepEvent();
}

class GetReferralStep extends ReferralStepEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetReferralStep({this.http, this.statusLoad, this.page});
}

class GetMoreReferralStep extends ReferralStepEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetMoreReferralStep({this.http, this.statusLoad, this.page});
}

part of 'referral_user_bloc.dart';

@immutable
abstract class ReferralUserState {
  const ReferralUserState();
}

class ReferralUserInitial extends ReferralUserState {
  const ReferralUserInitial();

  List<Object> get props => [];
}

class ReferralUserLoading extends ReferralUserState {
  const ReferralUserLoading();

  List<Object>? get props => null;
}

class ReferralUserMoreLoading extends ReferralUserState {
  const ReferralUserMoreLoading();

  List<Object>? get props => null;
}

class ReferralUserLoaded extends ReferralUserState {
  final List<DataReferralUser> list;
  final int? count;
  final int? limit;
  final int? totalReferral;
  final int? totalReferralValid;
  const ReferralUserLoaded(this.list, this.count, this.limit,
      this.totalReferral, this.totalReferralValid);

  List<Object?> get props => [list, count, limit];
}

class ReferralUserError extends ReferralUserState {
  final String message;

  const ReferralUserError(this.message);
  List<Object> get props => [message];
}

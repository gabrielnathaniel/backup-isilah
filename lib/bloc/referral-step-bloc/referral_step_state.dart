part of 'referral_step_bloc.dart';

@immutable
abstract class ReferralStepState {
  const ReferralStepState();
}

class ReferralStepInitial extends ReferralStepState {
  const ReferralStepInitial();

  List<Object> get props => [];
}

class ReferralStepLoading extends ReferralStepState {
  const ReferralStepLoading();

  List<Object>? get props => null;
}

class ReferralStepMoreLoading extends ReferralStepState {
  const ReferralStepMoreLoading();

  List<Object>? get props => null;
}

class ReferralStepLoaded extends ReferralStepState {
  final List<DataStep> list;
  final int? count;
  final int? limit;
  final int? totalReferral;
  final int? totalReferralValid;
  const ReferralStepLoaded(this.list, this.count, this.limit,
      this.totalReferral, this.totalReferralValid);

  List<Object?> get props => [list, count, limit];
}

class ReferralStepError extends ReferralStepState {
  final String message;

  const ReferralStepError(this.message);
  List<Object> get props => [message];
}

part of 'single_user_rank_bloc.dart';

@immutable
sealed class SingleUserRankState {
  const SingleUserRankState();
}

class SingleUserRankInitial extends SingleUserRankState {
  const SingleUserRankInitial();

  List<Object> get props => [];
}

class SingleUserRankLoading extends SingleUserRankState {
  const SingleUserRankLoading();

  List<Object>? get props => null;
}

class SingleUserRankLoaded extends SingleUserRankState {
  final SingleUserRanksModel singleUserRanksModel;
  const SingleUserRankLoaded(this.singleUserRanksModel);

  List<Object> get props => [singleUserRanksModel];
}

class SingleUserRankError extends SingleUserRankState {
  final String message;
  const SingleUserRankError(this.message);

  List<Object> get props => [message];
}

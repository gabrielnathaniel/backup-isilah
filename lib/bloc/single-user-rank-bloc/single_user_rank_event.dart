part of 'single_user_rank_bloc.dart';

@immutable
sealed class SingleUserRankEvent {
  const SingleUserRankEvent();
}

class GetSingleUserRank extends SingleUserRankEvent {
  final CHttp? http;
  final String? type;

  const GetSingleUserRank({this.http, this.type});
}

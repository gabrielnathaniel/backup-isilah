import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/single_rank.dart';
import 'package:isilahtitiktitik/resource/ranks_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'single_user_rank_event.dart';
part 'single_user_rank_state.dart';

class SingleUserRankBloc
    extends Bloc<SingleUserRankEvent, SingleUserRankState> {
  SingleUserRankBloc() : super(const SingleUserRankInitial()) {
    on<SingleUserRankEvent>((event, emit) async {
      if (event is GetSingleUserRank) {
        RanksApi ranksApi = RanksApi(http: event.http);
        try {
          emit(const SingleUserRankLoading());
          final userRank = await ranksApi.fetchUserRank(event.type!);
          emit(SingleUserRankLoaded(userRank));
        } catch (err) {
          emit(const SingleUserRankError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

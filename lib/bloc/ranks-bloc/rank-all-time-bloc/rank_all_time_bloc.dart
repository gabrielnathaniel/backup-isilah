import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/resource/ranks_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'rank_all_time_event.dart';
part 'rank_all_time_state.dart';

class RankAllTimeBloc extends Bloc<RankAllTimeEvent, RankAllTimeState> {
  RankAllTimeBloc() : super(const RankAllTimeInitial()) {
    List<DataRanks> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<RankAllTimeEvent>((event, emit) async {
      if (event is GetRankAllTime) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const RankAllTimeInitial());
          }

          if (state is RankAllTimeLoaded) {
            data = (state as RankAllTimeLoaded).list;
            currentLenght = (state as RankAllTimeLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const RankAllTimeMoreLoading());
          } else {
            emit(const RankAllTimeLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            RanksApi vendorVM = RanksApi(http: event.http);
            RanksModel reqData = await vendorVM.fetchRankAllTime(event.page!);

            limit = reqData.data!.total!;

            if (reqData.data!.data!.isNotEmpty) {
              data.addAll(reqData.data!.data!);
              if (currentLenght != 0) {
                currentLenght += reqData.data!.data!.length;
              } else {
                currentLenght = reqData.data!.data!.length;
              }
            } else {
              isLastPage = true;
            }
          }
          emit(RankAllTimeLoaded(data, currentLenght, limit));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const RankAllTimeNoAuth());
          } else if (err == 'Update Required') {
            emit(const RankAllTimeUpdateApp());
          } else {
            emit(RankAllTimeError(err.toString()));
          }
        }
      }
    });
  }
}

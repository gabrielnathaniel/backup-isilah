import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/resource/ranks_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'rank_weekly_event.dart';
part 'rank_weekly_state.dart';

class RankWeeklyBloc extends Bloc<RankWeeklyEvent, RankWeeklyState> {
  RankWeeklyBloc() : super(const RankWeeklyInitial()) {
    List<DataRanks> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<RankWeeklyEvent>((event, emit) async {
      if (event is GetRankWeekly) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const RankWeeklyInitial());
          }

          if (state is RankWeeklyLoaded) {
            data = (state as RankWeeklyLoaded).list;
            currentLenght = (state as RankWeeklyLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const RankWeeklyMoreLoading());
          } else {
            emit(const RankWeeklyLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            RanksApi vendorVM = RanksApi(http: event.http);
            RanksModel reqData = await vendorVM.fetchRankWeekly(event.page!);

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
          emit(RankWeeklyLoaded(data, currentLenght, limit));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const RankWeeklyNoAuth());
          } else if (err == 'Update Required') {
            emit(const RankWeeklyUpdateApp());
          } else {
            emit(RankWeeklyError(err.toString()));
          }
        }
      }
    });
  }
}

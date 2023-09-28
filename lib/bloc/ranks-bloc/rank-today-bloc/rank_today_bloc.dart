import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/resource/ranks_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'rank_today_event.dart';
part 'rank_today_state.dart';

class RankTodayBloc extends Bloc<RankTodayEvent, RankTodayState> {
  RankTodayBloc() : super(const RankTodayInitial()) {
    List<DataRanks> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<RankTodayEvent>((event, emit) async {
      if (event is GetRankToday) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const RankTodayInitial());
          }

          if (state is RankTodayLoaded) {
            data = (state as RankTodayLoaded).list;
            currentLenght = (state as RankTodayLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const RankTodayMoreLoading());
          } else {
            emit(const RankTodayLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            RanksApi vendorVM = RanksApi(http: event.http);
            RanksModel reqData = await vendorVM.fetchRankToday(event.page!);

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
          emit(RankTodayLoaded(data, currentLenght, limit));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const RankTodayNoAuth());
          } else if (err == 'Update Required') {
            emit(const RankTodayUpdateApp());
          } else {
            emit(RankTodayError(err.toString()));
          }
        }
      }
    });
  }
}

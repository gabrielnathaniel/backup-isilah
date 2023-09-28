import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/ranks.dart';
import 'package:isilahtitiktitik/resource/ranks_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'rank_monthly_event.dart';
part 'rank_monthly_state.dart';

class RankMonthlyBloc extends Bloc<RankMonthlyEvent, RankMonthlyState> {
  RankMonthlyBloc() : super(const RankMonthlyInitial()) {
    List<DataRanks> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<RankMonthlyEvent>((event, emit) async {
      if (event is GetRankMonthly) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const RankMonthlyInitial());
          }

          if (state is RankMonthlyLoaded) {
            data = (state as RankMonthlyLoaded).list;
            currentLenght = (state as RankMonthlyLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const RankMonthlyMoreLoading());
          } else {
            emit(const RankMonthlyLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            RanksApi vendorVM = RanksApi(http: event.http);
            RanksModel reqData = await vendorVM.fetchRankMonthly(event.page!);

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
          emit(RankMonthlyLoaded(data, currentLenght, limit));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const RankMonthlyNoAuth());
          } else if (err == 'Update Required') {
            emit(const RankMonthlyUpdateApp());
          } else {
            emit(RankMonthlyError(err.toString()));
          }
        }
      }
    });
  }
}

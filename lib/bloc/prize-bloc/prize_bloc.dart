import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/claim_finish.dart';
import 'package:isilahtitiktitik/model/claim_histories.dart';
import 'package:isilahtitiktitik/model/prize.dart';
import 'package:isilahtitiktitik/resource/prize_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

part 'prize_event.dart';
part 'prize_state.dart';

class PrizeBloc extends Bloc<PrizeEvent, PrizeState> {
  PrizeBloc() : super(const PrizeInitial()) {
    List<ClaimFinishData> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<PrizeEvent>((event, emit) async {
      if (event is GetPrize) {
        PrizeApi prizeApi = PrizeApi(http: event.http);
        try {
          emit(const GetPrizeLoading());
          final prizeData = await prizeApi.fetchPrize();
          emit(GetPrizeLoaded(prizeData));
        } catch (err) {
          emit(const GetPrizeError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      } else if (event is GetHistoriesClaim) {
        try {
          if (state is HistoriesClaimLoaded) {
            data = (state as HistoriesClaimLoaded).list;
            currentLenght = (state as HistoriesClaimLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const HistoriesClaimMoreLoading());
          } else {
            emit(const HistoriesClaimLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            PrizeApi vendorVM = PrizeApi(http: event.http);
            ClaimHistoriesModel reqData = await vendorVM.fetchHistoriesClaim(
                event.page!, event.search!, "date", "desc", '');

            Logger().d("dadas : ${reqData.data!.total}");
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
          emit(HistoriesClaimLoaded(data, currentLenght, limit));
        } catch (e) {
          Logger().d("object : ${e.toString()}");
          emit(const HistoriesClaimError(
              'Terjadi kesalahan saat berkomunikasi dengan server asdas'));
        }
      } else if (event is GetPrizeNextLevel) {
        BaseAuth auth = Provider.of<Auth>(event.context!, listen: false);
        PrizeApi prizeApi = PrizeApi(http: event.http);
        try {
          emit(const PrizeNextLevelLoading());
          final prizeData = await prizeApi.fetchPrizeNextLevel();
          emit(PrizeNextLevelLoaded(
              prizeData,
              auth.currentUser!.data!.user!.experiencePercentage,
              auth.currentUser!.data!.user!.experience,
              auth.currentUser!.data!.user!.level));
        } catch (err) {
          emit(const PrizeNextLevelError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

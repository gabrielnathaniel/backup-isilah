import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/leaderboard_treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'leaderboard_treasure_chest_event.dart';
part 'leaderboard_treasure_chest_state.dart';

class LeaderboardTreasureChestBloc
    extends Bloc<LeaderboardTreasureChestEvent, LeaderboardTreasureChestState> {
  LeaderboardTreasureChestBloc()
      : super(const LeaderboardTreasureChestInitial()) {
    List<LeaderboardTreasureChestList> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;
    on<LeaderboardTreasureChestEvent>((event, emit) async {
      if (event is GetLeaderboardTreasureChest) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const LeaderboardTreasureChestInitial());
          }
          if (state is LeaderboardTreasureChestLoaded) {
            data = (state as LeaderboardTreasureChestLoaded).list;
            currentLenght = (state as LeaderboardTreasureChestLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const LeaderboardTreasureChestMoreLoading());
          } else {
            emit(const LeaderboardTreasureChestLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            TreasureChestApi treasureChestApi =
                TreasureChestApi(http: event.http);
            LeaderboardTreasureChestModel reqData = await treasureChestApi
                .fetchLeaderboardTreasureChest(event.eventId!, event.page!);

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
          emit(LeaderboardTreasureChestLoaded(data, currentLenght, limit));
        } catch (e) {
          emit(const LeaderboardTreasureChestError(
              'Terjadi kesalahan saat berkomunikasi dengan server'));
        }
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/my_ranking_treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'my_ranking_treasure_chest_event.dart';
part 'my_ranking_treasure_chest_state.dart';

class MyRankingTreasureChestBloc
    extends Bloc<MyRankingTreasureChestEvent, MyRankingTreasureChestState> {
  MyRankingTreasureChestBloc() : super(const MyRankingTreasureChestInitial()) {
    on<MyRankingTreasureChestEvent>((event, emit) async {
      if (event is GetMyRankingTreasureChest) {
        TreasureChestApi treasureChestApi = TreasureChestApi(http: event.http);
        try {
          emit(const MyRankingTreasureChestLoading());

          final myRanking = await treasureChestApi
              .fetchMyRankingTreaseureChestModel(event.eventId!);

          emit(MyRankingTreasureChestLoaded(myRanking));
        } catch (err) {
          emit(const MyRankingTreasureChestError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

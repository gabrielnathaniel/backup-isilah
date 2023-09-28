import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/result_quiz.dart';
import 'package:isilahtitiktitik/model/treasure_chest.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'treasure_chest_event.dart';
part 'treasure_chest_state.dart';

class TreasureChestBloc extends Bloc<TreasureChestEvent, TreasureChestState> {
  TreasureChestBloc() : super(const TreasureChestInitial()) {
    on<TreasureChestEvent>((event, emit) async {
      if (event is GetPlayTreasureChest) {
        TreasureChestApi treasureChestApi = TreasureChestApi(http: event.http);

        try {
          emit(const PlayTreasureChestLoading());
          final playTreasureChestData =
              await treasureChestApi.fetchPlayTreasureChest(event.idQuiz!);
          emit(PlayTreasureChestLoaded(playTreasureChestData));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const PlayTreasureChestNoAuth());
          } else if (err == 'Update Required') {
            emit(const PlayTreasureChestUpdateApp());
          } else {
            emit(PlayTreasureChestError(err.toString()));
          }
        }
      } else if (event is GetResultTreasureChest) {
        TreasureChestApi treasureChestApi = TreasureChestApi(http: event.http);

        try {
          emit(const ResultTreasureChestLoading());
          final resultTreasureChestData =
              await treasureChestApi.fetchResultTreasureChest(event.idQuiz!);
          emit(ResultTreasureChestLoaded(resultTreasureChestData));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const ResultTreasureChestNoAuth());
          } else if (err == 'Update Required') {
            emit(const ResultTreasureChestUpdateApp());
          } else {
            emit(ResultTreasureChestError(err.toString()));
          }
        }
      }
    });
  }
}

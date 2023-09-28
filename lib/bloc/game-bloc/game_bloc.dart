import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/list_game.dart';
import 'package:isilahtitiktitik/resource/game_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameInitial()) {
    List<DataGame> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<GameEvent>((event, emit) async {
      if (event is GetListGame) {
        try {
          if (state is ListGameLoaded) {
            data = (state as ListGameLoaded).list;
            currentLenght = (state as ListGameLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const ListGameMoreLoading());
          } else {
            emit(const ListGameLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            GameApi vendorVM = GameApi(http: event.http);
            ListGameModel reqData = await vendorVM.fetchListGame(event.page!);

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
          emit(ListGameLoaded(data, currentLenght, limit));
        } catch (e) {
          if (e == 'Unauthorized') {
            emit(const ListGameNoAuth());
          } else if (e == 'Update Required') {
            emit(const ListGameUpdateApp());
          } else {
            emit(ListGameError(e.toString()));
          }
        }
      }
    });
  }
}

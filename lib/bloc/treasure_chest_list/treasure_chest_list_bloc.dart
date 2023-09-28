import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/treasure_chest_list.dart';
import 'package:isilahtitiktitik/resource/treasure_chest_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'treasure_chest_list_event.dart';
part 'treasure_chest_list_state.dart';

class TreasureChestListBloc
    extends Bloc<TreasureChestListEvent, TreasureChestListState> {
  TreasureChestListBloc() : super(const TreasureChestListInitial()) {
    on<TreasureChestListEvent>((event, emit) async {
      if (event is GetTreasureChestList) {
        TreasureChestApi treasureChestApi = TreasureChestApi(http: event.http);
        try {
          emit(const TreasureChestListLoading());
          final treasureChestData =
              await treasureChestApi.fetchTreasureChestList();
          emit(TreasureChestListLoaded(treasureChestData));
        } catch (err) {
          emit(const TreasureChestListError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

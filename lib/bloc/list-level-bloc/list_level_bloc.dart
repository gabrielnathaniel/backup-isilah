import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/level.dart';
import 'package:isilahtitiktitik/resource/level_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'list_level_event.dart';
part 'list_level_state.dart';

class ListLevelBloc extends Bloc<ListLevelEvent, ListLevelState> {
  ListLevelBloc() : super(const ListLevelInitial()) {
    on<ListLevelEvent>((event, emit) async {
      if (event is GetListLevel) {
        LevelApi levelApi = LevelApi(http: event.http);
        try {
          emit(const ListLevelLoading());
          final listLevelData = await levelApi.fetchListLevel();
          emit(ListLevelLoaded(listLevelData));
        } catch (err) {
          emit(const ListLevelError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

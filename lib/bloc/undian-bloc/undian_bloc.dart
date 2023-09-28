import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/pemenang_undian.dart';
import 'package:isilahtitiktitik/model/undian.dart';
import 'package:isilahtitiktitik/resource/prize_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'undian_event.dart';
part 'undian_state.dart';

class UndianBloc extends Bloc<UndianEvent, UndianState> {
  UndianBloc() : super(const UndianInitial()) {
    on<UndianEvent>((event, emit) async {
      if (event is GetUndian) {
        PrizeApi prizeApi = PrizeApi(http: event.http);
        try {
          emit(const UndianLoading());

          final undianData = await prizeApi.fetchUndian();

          emit(UndianLoaded(undianData));
        } catch (err) {
          emit(const UndianError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      } else if (event is GetPemenangUndian) {
        PrizeApi prizeApi = PrizeApi(http: event.http);
        try {
          emit(const PemenangUndianLoading());

          final undianData = await prizeApi.fetchPemenangUndian(event.date!);

          emit(PemenangUndianLoaded(undianData));
        } catch (err) {
          emit(const PemenangUndianError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

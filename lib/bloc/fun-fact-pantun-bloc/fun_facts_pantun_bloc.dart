import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/fun_fact_pantun.dart';
import 'package:isilahtitiktitik/resource/fun_fact_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'fun_facts_pantun_event.dart';
part 'fun_facts_pantun_state.dart';

class FunFactsPantunBloc
    extends Bloc<FunFactsPantunEvent, FunFactsPantunState> {
  FunFactsPantunBloc() : super(const FunFactsPantunInitial()) {
    on<FunFactsPantunEvent>((event, emit) async {
      if (event is GetFunFactsPantun) {
        FunFactApi funFactApi = FunFactApi(http: event.http);
        try {
          emit(const FunFactsPantunLoading());

          final userData = await funFactApi.fetchFunFactPantun();

          emit(FunFactsPantunLoaded(userData));
        } catch (err) {
          emit(const FunFactsPantunError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/promo.dart';
import 'package:isilahtitiktitik/resource/promo_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'promo_event.dart';
part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  PromoBloc() : super(const PromoInitial()) {
    on<PromoEvent>((event, emit) async {
      if (event is GetPromo) {
        PromoApi promoApi = PromoApi(http: event.http);
        try {
          emit(const GetPromoLoading());
          final prizeData = await promoApi.fetchPromo();
          emit(GetPromoLoaded(prizeData));
        } catch (err) {
          emit(const GetPromoError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

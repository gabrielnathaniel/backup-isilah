import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/faq.dart';
import 'package:isilahtitiktitik/resource/faq_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc() : super(const FaqInitial()) {
    List<Data> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<FaqEvent>((event, emit) async {
      if (event is GetFaq) {
        try {
          if (state is FaqLoaded) {
            data = (state as FaqLoaded).list;
            currentLenght = (state as FaqLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const FaqMoreLoading());
          } else {
            emit(const FaqLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            FaqApi vendorVM = FaqApi(http: event.http);
            FaqModel reqData = await vendorVM.fetchFaq(event.page!);

            Logger().d("Response FAQ : ${reqData.data}");
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
          emit(FaqLoaded(data, currentLenght, limit));
        } catch (e) {
          Logger().d("object : ${e.toString()}");
          emit(const FaqError(
              'Terjadi kesalahan saat berkomunikasi dengan server'));
        }
      }
    });
  }
}

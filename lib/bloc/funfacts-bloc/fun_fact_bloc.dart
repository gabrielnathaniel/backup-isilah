import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/detail_fun_fact.dart';
import 'package:isilahtitiktitik/model/fun_fact.dart';
import 'package:isilahtitiktitik/resource/fun_fact_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

part 'fun_fact_event.dart';
part 'fun_fact_state.dart';

class FunFactBloc extends Bloc<FunFactEvent, FunFactState> {
  FunFactBloc() : super(const FunFactInitial()) {
    List<DataFunFact> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<FunFactEvent>((event, emit) async {
      if (event is GetFunFact) {
        try {
          if (event.isRefresh == true) {
            data.clear();
            currentLenght = 0;
            emit(const FunFactInitial());
          }

          if (state is FunFactLoaded) {
            data = (state as FunFactLoaded).list;
            currentLenght = (state as FunFactLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const FunFactMoreLoading());
          } else {
            emit(const FunFactLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            FunFactApi vendorVM = FunFactApi(http: event.http);
            FunFactModel reqData = await vendorVM.fetchFunFact(event.page!);

            Logger().d("Response Fun Fact Data : ${reqData.data}");
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
          emit(FunFactLoaded(data, currentLenght, limit));
        } catch (e) {
          Logger().d("object : ${e.toString()}");
          emit(FunFactError(e.toString()));
        }
      } else if (event is GetDetailFunFact) {
        FunFactApi funFactApi = FunFactApi(http: event.http);
        try {
          emit(const DetailFunFactLoading());
          final detailFunFactData =
              await funFactApi.fetchDetailFunFact(event.id!);
          emit(DetailFunFactLoaded(detailFunFactData));
        } catch (err) {
          emit(DetailFunFactError(err.toString()));
        }
      } else if (event is GetFunFactCaraousel) {
        FunFactApi funFactApi = FunFactApi(http: event.http);
        try {
          emit(const FunFactCarouselLoading());
          final funFactCarouselData = await funFactApi.fetchFunFactCarousel();
          emit(FunFactCarouselLoaded(funFactCarouselData));
        } catch (err) {
          emit(const FunFactCarouselError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

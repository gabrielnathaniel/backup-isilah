import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/history.dart';
import 'package:isilahtitiktitik/resource/history_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/helper.dart';
import 'package:logger/logger.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const HistoryInitial()) {
    List<Data> data = [];
    int currentLenght = 0;
    int limit = 0;
    bool? isLastPage;

    on<HistoryEvent>((event, emit) async {
      if (event is GetHistory) {
        try {
          if (event.statusRefresh!) {
            data.clear();
            currentLenght = 0;
            emit(const HistoryInitial());
          }

          if (state is HistoryLoaded) {
            data = (state as HistoryLoaded).list;
            currentLenght = (state as HistoryLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const HistoryMoreLoading());
          } else {
            emit(const HistoryLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            HistoryApi vendorVM = HistoryApi(http: event.http);
            HistoryModel reqData = await vendorVM.fetchHistory(
                IsilahHelper.formatDates(DateTime.parse(event.startDate!)),
                IsilahHelper.formatDates(DateTime.parse(event.endDate!)),
                event.page!);

            Logger().d("Response History : ${reqData.data}");
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
          emit(HistoryLoaded(data, currentLenght, limit));
        } catch (e) {
          if (e == 'Unauthorized') {
            emit(const HistoryNoAuth());
          } else if (e == 'Update Required') {
            emit(const HistoryUpdateApp());
          } else {
            emit(HistoryError(e.toString()));
          }
        }
      }
    });
  }
}

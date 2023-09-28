import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/referral_step.dart';
import 'package:isilahtitiktitik/resource/referral_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'referral_step_event.dart';
part 'referral_step_state.dart';

class ReferralStepBloc extends Bloc<ReferralStepEvent, ReferralStepState> {
  ReferralStepBloc() : super(const ReferralStepInitial()) {
    List<DataStep> data = [];
    int currentLenght = 0;
    int limit = 0;
    int referral = 0;
    int referralValid = 0;
    bool? isLastPage;
    on<ReferralStepEvent>((event, emit) async {
      if (event is GetReferralStep) {
        try {
          if (state is ReferralStepLoaded) {
            data = (state as ReferralStepLoaded).list;
            currentLenght = (state as ReferralStepLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const ReferralStepMoreLoading());
          } else {
            emit(const ReferralStepLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            ReferralApi vendorVM = ReferralApi(http: event.http);
            ReferralStepModel reqData =
                await vendorVM.fetchReferralStep(event.page!);

            limit = reqData.data!.data!.total!;
            referral = reqData.data!.header!.totalRefferal!;
            referralValid = reqData.data!.header!.totalRefferalValid!;

            if (reqData.data!.data!.data!.isNotEmpty) {
              data.addAll(reqData.data!.data!.data!);
              if (currentLenght != 0) {
                currentLenght += reqData.data!.data!.data!.length;
              } else {
                currentLenght = reqData.data!.data!.data!.length;
              }
            } else {
              isLastPage = true;
            }
          }
          emit(ReferralStepLoaded(
              data, currentLenght, limit, referral, referralValid));
        } catch (e) {
          emit(const ReferralStepError(
              'Terjadi kesalahan saat berkomunikasi dengan server'));
        }
      }
    });
  }
}

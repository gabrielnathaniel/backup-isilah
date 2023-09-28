import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/referral_user.dart';
import 'package:isilahtitiktitik/resource/referral_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'referral_user_event.dart';
part 'referral_user_state.dart';

class ReferralUserBloc extends Bloc<ReferralUserEvent, ReferralUserState> {
  ReferralUserBloc() : super(const ReferralUserInitial()) {
    List<DataReferralUser> data = [];
    int currentLenght = 0;
    int limit = 0;
    int referral = 0;
    int referralValid = 0;
    bool? isLastPage;
    on<ReferralUserEvent>((event, emit) async {
      if (event is GetReferralUser) {
        try {
          if (state is ReferralUserLoaded) {
            data = (state as ReferralUserLoaded).list;
            currentLenght = (state as ReferralUserLoaded).count!;
          }

          if (currentLenght != 0) {
            emit(const ReferralUserMoreLoading());
          } else {
            emit(const ReferralUserLoading());
          }

          if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
            if (event.statusLoad == true) {
              currentLenght = 0;
            }

            ReferralApi vendorVM = ReferralApi(http: event.http);
            ReferralUserModel reqData =
                await vendorVM.fetchReferralUser(event.page!);

            limit = reqData.data!.data!.total!;
            referral = reqData.data!.header!.totalRefferal!;

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
          emit(ReferralUserLoaded(
              data, currentLenght, limit, referral, referralValid));
        } catch (e) {
          emit(const ReferralUserError(
              'Terjadi kesalahan saat berkomunikasi dengan server'));
        }
      }
    });
  }
}

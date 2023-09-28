// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:isilahtitiktitik/model/ranks.dart';
// import 'package:isilahtitiktitik/resource/ranks_api.dart';
// import 'package:isilahtitiktitik/utils/api_helper.dart';

// part 'rank_by_type_event.dart';
// part 'rank_by_type_state.dart';

// class RankByTypeBloc extends Bloc<RankByTypeEvent, RankByTypeState> {
//   RankByTypeBloc() : super(const RankByTypeInitial()) {
//     List<DataRanks> data = [];
//     int currentLenght = 0;
//     int limit = 0;
//     bool? isLastPage;

//     on<RankByTypeEvent>((event, emit) async {
//       if (event is GetRankByType) {
//         try {
//           if (event.isRefresh == true) {
//             data.clear();
//             currentLenght = 0;
//             emit(const RankByTypeInitial());
//           }

//           if (state is RankByTypeLoaded) {
//             data = (state as RankByTypeLoaded).list;
//             currentLenght = (state as RankByTypeLoaded).count!;
//           }

//           if (currentLenght != 0) {
//             emit(const RankByTypeMoreLoading());
//           } else {
//             emit(const RankByTypeLoading());
//           }

//           if (currentLenght == 0 || isLastPage == null || !isLastPage!) {
//             if (event.statusLoad == true) {
//               currentLenght = 0;
//             }

//             RanksApi vendorVM = RanksApi(http: event.http);
//             RanksModel reqData =
//                 await vendorVM.fetchRankByType(event.page!, event.type!);

//             limit = reqData.data!.total!;

//             if (reqData.data!.data!.isNotEmpty) {
//               data.addAll(reqData.data!.data!);
//               if (currentLenght != 0) {
//                 currentLenght += reqData.data!.data!.length;
//               } else {
//                 currentLenght = reqData.data!.data!.length;
//               }
//             } else {
//               isLastPage = true;
//             }
//           }
//           emit(RankByTypeLoaded(data, currentLenght, limit));
//         } catch (err) {
//           if (err == 401) {
//             emit(const RankByTypeNoAuth());
//           } else {
//             emit(const RankByTypeError(
//                 'Terjadi kesalahan saat berkomunikasi dengan server'));
//           }
//         }
//       }
//     });
//   }
// }

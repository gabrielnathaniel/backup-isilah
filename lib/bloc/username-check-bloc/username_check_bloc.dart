import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/username_check.dart';
import 'package:isilahtitiktitik/resource/single_user_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'username_check_event.dart';
part 'username_check_state.dart';

class UsernameCheckBloc extends Bloc<UsernameCheckEvent, UsernameCheckState> {
  UsernameCheckBloc() : super(const UsernameCheckInitial()) {
    on<UsernameCheckEvent>((event, emit) async {
      if (event is GetUsernameCheck) {
        SingleUserApi singleUserApi = SingleUserApi(http: event.http);
        try {
          emit(const UsernameCheckLoading());

          final usernameCheck = await singleUserApi.fetchUsernameCheck();

          emit(UsernameCheckLoaded(usernameCheck));
        } catch (err) {
          emit(const UsernameCheckError(
              'Terjadi kesalahan saat terhubung dengan server'));
        }
      }
    });
  }
}

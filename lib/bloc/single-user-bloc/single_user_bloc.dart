import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/user.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:isilahtitiktitik/utils/auth.dart';

part 'single_user_event.dart';
part 'single_user_state.dart';

class SingleUserBloc extends Bloc<SingleUserEvent, SingleUserState> {
  SingleUserBloc() : super(const SingleUserInitial()) {
    on<SingleUserEvent>((event, emit) async {
      if (event is GetSingleUser) {
        try {
          emit(const SingleUserLoading());

          final userData = await event.baseAuth!.loadSingleUser();

          emit(SingleUserLoaded(userData!));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const SingleUserNotAuth());
          } else if (err == 'Update Required') {
            emit(const SingleUserUpdateApp());
          } else {
            emit(SingleUserError(err.toString()));
          }
        }
      }
    });
  }
}

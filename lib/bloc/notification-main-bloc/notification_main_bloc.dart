import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/notification_main.dart';
import 'package:isilahtitiktitik/resource/notification_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'notification_main_event.dart';
part 'notification_main_state.dart';

class NotificationMainBloc
    extends Bloc<NotificationMainEvent, NotificationMainState> {
  NotificationMainBloc() : super(const NotificationMainInitial()) {
    on<NotificationMainEvent>((event, emit) async {
      if (event is GetNotificationMain) {
        NotificationApi notificationApi = NotificationApi(http: event.http);
        try {
          if (!event.isRefresh!) {
            emit(const NotificationMainLoading());
          }
          final notificationMainData =
              await notificationApi.fetchNotification();
          emit(NotificationMainLoaded(notificationMainData));
        } catch (err) {
          emit(NotificationMainError(err.toString()));
        }
      }
    });
  }
}

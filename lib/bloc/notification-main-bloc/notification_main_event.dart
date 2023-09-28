part of 'notification_main_bloc.dart';

@immutable
abstract class NotificationMainEvent {
  const NotificationMainEvent();
}

class GetNotificationMain extends NotificationMainEvent {
  final CHttp? http;
  final bool? isRefresh;

  const GetNotificationMain({this.http, this.isRefresh});
}

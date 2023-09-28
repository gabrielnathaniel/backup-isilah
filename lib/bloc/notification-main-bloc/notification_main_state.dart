part of 'notification_main_bloc.dart';

@immutable
abstract class NotificationMainState {
  const NotificationMainState();
}

class NotificationMainInitial extends NotificationMainState {
  const NotificationMainInitial();

  List<Object> get props => [];
}

class NotificationMainLoading extends NotificationMainState {
  const NotificationMainLoading();

  List<Object>? get props => null;
}

class NotificationMainLoaded extends NotificationMainState {
  final NotificationModel notificationModel;
  const NotificationMainLoaded(this.notificationModel);

  List<Object?> get props => [notificationModel];
}

class NotificationMainError extends NotificationMainState {
  final String message;

  const NotificationMainError(this.message);
  List<Object> get props => [message];
}

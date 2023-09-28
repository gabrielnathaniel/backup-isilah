part of 'username_check_bloc.dart';

@immutable
abstract class UsernameCheckEvent {
  const UsernameCheckEvent();
}

class GetUsernameCheck extends UsernameCheckEvent {
  final CHttp? http;

  const GetUsernameCheck({this.http});
}

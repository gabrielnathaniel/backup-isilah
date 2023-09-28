part of 'single_user_bloc.dart';

@immutable
abstract class SingleUserEvent {
  const SingleUserEvent();
}

class GetSingleUser extends SingleUserEvent {
  final CHttp? http;
  final BaseAuth? baseAuth;

  const GetSingleUser({this.http, this.baseAuth});
}

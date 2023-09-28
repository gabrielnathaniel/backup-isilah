part of 'game_bloc.dart';

@immutable
abstract class GameEvent {
  const GameEvent();
}

class GetListGame extends GameEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetListGame({this.http, this.statusLoad, this.page});
}

class GetMoreListGame extends GameEvent {
  final CHttp? http;
  final int? page;
  final bool? statusLoad;
  const GetMoreListGame({this.http, this.statusLoad, this.page});
}

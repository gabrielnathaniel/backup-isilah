part of 'game_bloc.dart';

@immutable
abstract class GameState {
  const GameState();
}

class GameInitial extends GameState {
  const GameInitial();

  List<Object> get props => [];
}

class ListGameLoading extends GameState {
  const ListGameLoading();

  List<Object>? get props => null;
}

class ListGameMoreLoading extends GameState {
  const ListGameMoreLoading();

  List<Object>? get props => null;
}

class ListGameLoaded extends GameState {
  final List<DataGame> list;
  final int? count;
  final int? limit;
  const ListGameLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class ListGameError extends GameState {
  final String message;

  const ListGameError(this.message);
  List<Object> get props => [message];
}

class ListGameNoAuth extends GameState {
  const ListGameNoAuth();
  List<Object> get props => [];
}

class ListGameUpdateApp extends GameState {
  const ListGameUpdateApp();
  List<Object> get props => [];
}

part of 'list_level_bloc.dart';

@immutable
abstract class ListLevelState {
  const ListLevelState();
}

class ListLevelInitial extends ListLevelState {
  const ListLevelInitial();

  List<Object> get props => [];
}

class ListLevelLoading extends ListLevelState {
  const ListLevelLoading();

  List<Object>? get props => null;
}

class ListLevelLoaded extends ListLevelState {
  final LevelModel levelModel;
  const ListLevelLoaded(this.levelModel);

  List<Object?> get props => [levelModel];
}

class ListLevelError extends ListLevelState {
  final String message;

  const ListLevelError(this.message);
  List<Object> get props => [message];
}

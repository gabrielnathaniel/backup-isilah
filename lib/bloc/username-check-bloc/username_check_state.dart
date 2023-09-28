part of 'username_check_bloc.dart';

@immutable
abstract class UsernameCheckState {
  const UsernameCheckState();
}

class UsernameCheckInitial extends UsernameCheckState {
  const UsernameCheckInitial();

  List<Object> get props => [];
}

class UsernameCheckLoading extends UsernameCheckState {
  const UsernameCheckLoading();

  List<Object>? get props => null;
}

class UsernameCheckLoaded extends UsernameCheckState {
  final UsernameCheckModel? usernameCheckModel;

  const UsernameCheckLoaded(this.usernameCheckModel);

  List<Object?> get props => [usernameCheckModel];
}

class UsernameCheckError extends UsernameCheckState {
  final String message;

  const UsernameCheckError(this.message);
  List<Object> get props => [message];
}

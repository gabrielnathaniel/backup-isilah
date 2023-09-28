part of 'single_user_bloc.dart';

@immutable
abstract class SingleUserState {
  const SingleUserState();
}

class SingleUserInitial extends SingleUserState {
  const SingleUserInitial();

  List<Object> get props => [];
}

class SingleUserLoading extends SingleUserState {
  const SingleUserLoading();

  List<Object>? get props => null;
}

class SingleUserLoaded extends SingleUserState {
  final User user;

  const SingleUserLoaded(this.user);

  List<Object?> get props => [user];
}

class SingleUserError extends SingleUserState {
  final String message;

  const SingleUserError(this.message);
  List<Object> get props => [message];
}

class SingleUserNotAuth extends SingleUserState {
  const SingleUserNotAuth();
  List<Object> get props => [];
}

class SingleUserUpdateApp extends SingleUserState {
  const SingleUserUpdateApp();
  List<Object> get props => [];
}

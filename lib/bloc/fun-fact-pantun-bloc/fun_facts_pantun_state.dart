part of 'fun_facts_pantun_bloc.dart';

@immutable
abstract class FunFactsPantunState {
  const FunFactsPantunState();
}

class FunFactsPantunInitial extends FunFactsPantunState {
  const FunFactsPantunInitial();

  List<Object> get props => [];
}

class FunFactsPantunLoading extends FunFactsPantunState {
  const FunFactsPantunLoading();

  List<Object>? get props => null;
}

class FunFactsPantunLoaded extends FunFactsPantunState {
  final FunFactPantunModel? funFactPantunModel;

  const FunFactsPantunLoaded(this.funFactPantunModel);

  List<Object?> get props => [funFactPantunModel];
}

class FunFactsPantunError extends FunFactsPantunState {
  final String message;

  const FunFactsPantunError(this.message);
  List<Object> get props => [message];
}

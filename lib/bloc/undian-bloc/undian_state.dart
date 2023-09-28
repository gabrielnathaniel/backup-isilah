part of 'undian_bloc.dart';

@immutable
abstract class UndianState {
  const UndianState();
}

class UndianInitial extends UndianState {
  const UndianInitial();

  List<Object> get props => [];
}

/// Get Undian
class UndianLoading extends UndianState {
  const UndianLoading();

  List<Object>? get props => null;
}

class UndianLoaded extends UndianState {
  final UndianModel? undianModel;

  const UndianLoaded(this.undianModel);

  List<Object?> get props => [undianModel];
}

class UndianError extends UndianState {
  final String message;

  const UndianError(this.message);
  List<Object> get props => [message];
}

/// Get Pemenang Undian
class PemenangUndianLoading extends UndianState {
  const PemenangUndianLoading();

  List<Object>? get props => null;
}

class PemenangUndianLoaded extends UndianState {
  final PemenangUndianModel? pemenangUndianModel;

  const PemenangUndianLoaded(this.pemenangUndianModel);

  List<Object?> get props => [pemenangUndianModel];
}

class PemenangUndianError extends UndianState {
  final String message;

  const PemenangUndianError(this.message);
  List<Object> get props => [message];
}

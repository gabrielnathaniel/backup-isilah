part of 'faq_bloc.dart';

@immutable
abstract class FaqState {
  const FaqState();
}

class FaqInitial extends FaqState {
  const FaqInitial();

  List<Object> get props => [];
}

class FaqLoading extends FaqState {
  const FaqLoading();

  List<Object>? get props => null;
}

class FaqMoreLoading extends FaqState {
  const FaqMoreLoading();

  List<Object>? get props => null;
}

class FaqLoaded extends FaqState {
  final List<Data> list;
  final int? count;
  final int? limit;
  const FaqLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class FaqError extends FaqState {
  final String message;

  const FaqError(this.message);
  List<Object> get props => [message];
}

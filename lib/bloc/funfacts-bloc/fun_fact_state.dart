part of 'fun_fact_bloc.dart';

@immutable
abstract class FunFactState {
  const FunFactState();
}

class FunFactInitial extends FunFactState {
  const FunFactInitial();

  List<Object> get props => [];
}

class FunFactLoading extends FunFactState {
  const FunFactLoading();

  List<Object>? get props => null;
}

class FunFactMoreLoading extends FunFactState {
  const FunFactMoreLoading();

  List<Object>? get props => null;
}

class FunFactLoaded extends FunFactState {
  final List<DataFunFact> list;
  final int? count;
  final int? limit;
  const FunFactLoaded(this.list, this.count, this.limit);

  List<Object?> get props => [list, count, limit];
}

class FunFactError extends FunFactState {
  final String message;

  const FunFactError(this.message);
  List<Object> get props => [message];
}

// Detail Fun Fact
class DetailFunFactLoading extends FunFactState {
  const DetailFunFactLoading();

  List<Object>? get props => null;
}

class DetailFunFactLoaded extends FunFactState {
  final DetailFunFactModel detailFunFactModel;
  const DetailFunFactLoaded(this.detailFunFactModel);

  List<Object> get props => [detailFunFactModel];
}

class DetailFunFactError extends FunFactState {
  final String message;
  const DetailFunFactError(this.message);

  List<Object> get props => [message];
}

// Fun Fact Carousel
class FunFactCarouselLoading extends FunFactState {
  const FunFactCarouselLoading();

  List<Object>? get props => null;
}

class FunFactCarouselLoaded extends FunFactState {
  final FunFactModel factModel;
  const FunFactCarouselLoaded(this.factModel);

  List<Object?> get props => [factModel];
}

class FunFactCarouselError extends FunFactState {
  final String message;

  const FunFactCarouselError(this.message);
  List<Object> get props => [message];
}

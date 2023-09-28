part of 'fun_facts_pantun_bloc.dart';

@immutable
abstract class FunFactsPantunEvent {
  const FunFactsPantunEvent();
}

class GetFunFactsPantun extends FunFactsPantunEvent {
  final CHttp? http;

  const GetFunFactsPantun({this.http});
}

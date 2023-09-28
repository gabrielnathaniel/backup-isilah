part of 'treasure_chest_bloc.dart';

@immutable
abstract class TreasureChestEvent {
  const TreasureChestEvent();
}

class GetPlayTreasureChest extends TreasureChestEvent {
  final CHttp? http;
  final int? idQuiz;

  const GetPlayTreasureChest({this.http, this.idQuiz});
}

class GetResultTreasureChest extends TreasureChestEvent {
  final CHttp? http;
  final int? idQuiz;

  const GetResultTreasureChest({this.http, this.idQuiz});
}

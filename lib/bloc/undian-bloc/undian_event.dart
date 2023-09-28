part of 'undian_bloc.dart';

@immutable
abstract class UndianEvent {
  const UndianEvent();
}

class GetUndian extends UndianEvent {
  final CHttp? http;

  const GetUndian({this.http});
}

class GetPemenangUndian extends UndianEvent {
  final CHttp? http;
  final String? date;

  const GetPemenangUndian({this.http, this.date});
}

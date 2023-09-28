part of 'list_level_bloc.dart';

@immutable
abstract class ListLevelEvent {
  const ListLevelEvent();
}

class GetListLevel extends ListLevelEvent {
  final CHttp? http;

  const GetListLevel({this.http});
}

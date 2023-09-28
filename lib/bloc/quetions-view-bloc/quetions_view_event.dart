part of 'quetions_view_bloc.dart';

@immutable
sealed class QuetionsViewEvent {
  const QuetionsViewEvent();
}

class GetQuetionsView extends QuetionsViewEvent {
  final CHttp? http;
  final int? questionId;

  const GetQuetionsView({this.http, this.questionId});
}

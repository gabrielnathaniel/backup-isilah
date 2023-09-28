part of 'quiz_bloc.dart';

@immutable
abstract class QuizEvent {
  const QuizEvent();
}

class GetDailyEvent extends QuizEvent {
  final CHttp? http;
  final String? timezone;
  final int? gmt;

  const GetDailyEvent({this.http, this.timezone, this.gmt});
}

class GetPlayQuiz extends QuizEvent {
  final CHttp? http;
  final int? idQuiz;

  const GetPlayQuiz({this.http, this.idQuiz});
}

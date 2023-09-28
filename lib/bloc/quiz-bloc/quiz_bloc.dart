import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/daily_event.dart';
import 'package:isilahtitiktitik/model/play_quiz.dart';
import 'package:isilahtitiktitik/resource/quiz_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(const QuizInitial()) {
    on<QuizEvent>((event, emit) async {
      if (event is GetDailyEvent) {
        QuizApi quizApi = QuizApi(http: event.http);
        try {
          emit(const DailyEventLoading());
          final dailyEventData =
              await quizApi.fetchDailyEvent(event.timezone!, event.gmt!);
          emit(DailyEventLoaded(dailyEventData));
        } catch (err) {
          emit(DailyEventError(
              'Terjadi kesalahan saat terhubung dengan server $err'));
        }
      } else if (event is GetPlayQuiz) {
        QuizApi quizApi = QuizApi(http: event.http);
        try {
          emit(const PlayQuizLoading());
          final playQuizData = await quizApi.fetchPlayQuiz(event.idQuiz!);
          emit(PlayQuizLoaded(playQuizData));
        } catch (err) {
          if (err == 'Unauthorized') {
            emit(const PlayQuizNoAuth());
          } else if (err == 'Update Required') {
            emit(const PlayQuizUpdateApp());
          } else {
            emit(PlayQuizError(err.toString()));
          }
        }
      }
    });
  }
}

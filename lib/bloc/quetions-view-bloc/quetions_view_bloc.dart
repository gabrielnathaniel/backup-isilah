import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isilahtitiktitik/model/quetions_view.dart';
import 'package:isilahtitiktitik/resource/quiz_api.dart';
import 'package:isilahtitiktitik/utils/api_helper.dart';
import 'package:logger/logger.dart';

part 'quetions_view_event.dart';
part 'quetions_view_state.dart';

class QuetionsViewBloc extends Bloc<QuetionsViewEvent, QuetionsViewState> {
  QuetionsViewBloc() : super(const QuetionsViewInitial()) {
    on<QuetionsViewEvent>((event, emit) async {
      if (event is GetQuetionsView) {
        final QuizApi quizApi = QuizApi(http: event.http);
        try {
          emit(const QuetionsViewLoading());

          final quetionsView =
              await quizApi.fetchQuestionsView(event.questionId!);

          emit(QuetionsViewLoaded(quetionsView));
        } catch (e) {
          Logger().d("Error Quetions View: $e");
          if (e == 'Unauthorized') {
            emit(const QuetionsViewNoAuth());
          } else if (e == 'Update Required') {
            emit(const QuetionsViewUpdateApp());
          } else {
            emit(QuetionsViewError(e.toString()));
          }
        }
      }
    });
  }
}

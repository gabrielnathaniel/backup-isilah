part of 'quiz_bloc.dart';

@immutable
abstract class QuizState {
  const QuizState();
}

class QuizInitial extends QuizState {
  const QuizInitial();

  List<Object> get props => [];
}

// Daily Event
class DailyEventLoading extends QuizState {
  const DailyEventLoading();

  List<Object>? get props => null;
}

class DailyEventLoaded extends QuizState {
  final DailyEventModel dailyEventModel;
  const DailyEventLoaded(this.dailyEventModel);

  List<Object?> get props => [dailyEventModel];
}

class DailyEventError extends QuizState {
  final String message;

  const DailyEventError(this.message);
  List<Object> get props => [message];
}

// Play Quiz Event
class PlayQuizLoading extends QuizState {
  const PlayQuizLoading();

  List<Object>? get props => null;
}

class PlayQuizLoaded extends QuizState {
  final PlayQuizModel playQuizModel;
  const PlayQuizLoaded(this.playQuizModel);

  List<Object?> get props => [playQuizModel];
}

class PlayQuizError extends QuizState {
  final String message;

  const PlayQuizError(this.message);
  List<Object> get props => [message];
}

class PlayQuizNoAuth extends QuizState {
  const PlayQuizNoAuth();
  List<Object> get props => [];
}

class PlayQuizUpdateApp extends QuizState {
  const PlayQuizUpdateApp();
  List<Object> get props => [];
}

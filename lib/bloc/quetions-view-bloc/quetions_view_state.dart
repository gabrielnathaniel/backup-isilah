part of 'quetions_view_bloc.dart';

@immutable
sealed class QuetionsViewState {
  const QuetionsViewState();
}

final class QuetionsViewInitial extends QuetionsViewState {
  const QuetionsViewInitial();

  List<Object> get props => [];
}

class QuetionsViewLoading extends QuetionsViewState {
  const QuetionsViewLoading();

  List<Object>? get props => null;
}

class QuetionsViewLoaded extends QuetionsViewState {
  final QuetionsViewModel? quetionsViewModel;
  const QuetionsViewLoaded(this.quetionsViewModel);

  List<Object?> get props => [quetionsViewModel];
}

class QuetionsViewError extends QuetionsViewState {
  final String message;

  const QuetionsViewError(this.message);
  List<Object> get props => [message];
}

class QuetionsViewNoAuth extends QuetionsViewState {
  const QuetionsViewNoAuth();
  List<Object> get props => [];
}

class QuetionsViewUpdateApp extends QuetionsViewState {
  const QuetionsViewUpdateApp();
  List<Object> get props => [];
}

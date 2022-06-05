import 'package:zebu_app/bloc/feedback/feedback_event.dart';
import 'package:zebu_app/bloc/feedback/feedback_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zebu_app/repository/feedback_repository.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository feedbackRepository;

  FeedbackBloc({required this.feedbackRepository}) : super(LoadingFeedback());

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
  
    if (event is Post) {
      yield LoadingFeedback();
      try {
        final status = await feedbackRepository.createFeedback(event.feedback);
        if (status == 'Feedback created') {
          yield FeedbackSuccess();
        }
      } catch (error) {
        print(error);

        yield FeedbackFailure();
      }
    }

    
  }
}

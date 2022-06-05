import 'package:equatable/equatable.dart';
import 'package:zebu_app/models/feedback.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
}


class Post extends FeedbackEvent {
  final MyFeedBack feedback;
  const Post(this.feedback);

  
  List<Object?> get props => [];
}

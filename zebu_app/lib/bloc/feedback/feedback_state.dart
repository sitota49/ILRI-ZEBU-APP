import 'package:equatable/equatable.dart';

class FeedbackState extends Equatable {
  const FeedbackState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingFeedback extends FeedbackState {}


class FeedbackSuccess extends FeedbackState {
  @override
  List<Object> get props => [];
}

class FeedbackFailure extends FeedbackState {
  @override
  List<Object> get props => [];
}

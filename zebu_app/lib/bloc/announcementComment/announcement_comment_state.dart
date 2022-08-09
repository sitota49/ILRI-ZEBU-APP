import 'package:equatable/equatable.dart';

class AnnouncementCommentState extends Equatable {
  const AnnouncementCommentState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingAnnouncementComment extends AnnouncementCommentState {}


class AnnouncementCommentSuccess extends AnnouncementCommentState {
  @override
  List<Object> get props => [];
}

class AnnouncementCommentFailure extends AnnouncementCommentState {
  @override
  List<Object> get props => [];
}

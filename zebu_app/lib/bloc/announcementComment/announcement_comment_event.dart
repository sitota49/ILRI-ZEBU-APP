import 'package:equatable/equatable.dart';
import 'package:zebu_app/models/announcementComment.dart';

abstract class AnnouncementCommentEvent extends Equatable {
  const AnnouncementCommentEvent();
}

class Post extends AnnouncementCommentEvent {
  final AnnouncementComment announcementComment;
  const Post(this.announcementComment);

  List<Object?> get props => [];
}

import 'package:zebu_app/bloc/announcementComment/announcement_comment_event.dart';
import 'package:zebu_app/bloc/announcementComment/announcement_comment_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/repository/announcement_comment_repository.dart';

class AnnouncementCommentBloc
    extends Bloc<AnnouncementCommentEvent, AnnouncementCommentState> {
  final AnnouncementCommentRepository announcementCommentRepository;

  AnnouncementCommentBloc({required this.announcementCommentRepository})
      : super(LoadingAnnouncementComment());

  @override
  Stream<AnnouncementCommentState> mapEventToState(
      AnnouncementCommentEvent event) async* {
    if (event is Post) {
      yield LoadingAnnouncementComment();
      try {
        final status = await announcementCommentRepository
            .createAnnouncementComment(event.announcementComment);

        yield AnnouncementCommentSuccess();
      } catch (error) {
        print(error);

        yield AnnouncementCommentFailure();
      }
    }
  }
}

import 'package:zebu_app/bloc/announcement/announcement_bloc.dart';
import 'package:zebu_app/bloc/announcement/announcement_event.dart';
import 'package:zebu_app/bloc/announcement/announcement_state.dart';
import 'package:zebu_app/repository/announcement_repositiory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementRepository announcementRepository;

  AnnouncementBloc({required this.announcementRepository}) : super(LoadingAnnouncement());

  @override
  Stream<AnnouncementState> mapEventToState(AnnouncementEvent event) async* {
    if (event is AnnouncementsLoad) {
      yield LoadingAnnouncement();
      try {
        final posts = await announcementRepository.getAnnouncements();
        if (posts.isEmpty) {
          yield const AnnouncementsEmpltyFailure(
              message: "No Announcements Found");
        } else {
          yield AnnouncementsLoadSuccess(posts);
        }
      } catch (error) {
        print(error);
        yield AnnouncementsLoadFailure();
      }
    }
    if (event is AnnouncementLoad) {
      yield LoadingAnnouncement();
      try {
        final announcement = await announcementRepository.getAnnouncement(event.id);

        if (announcement != null) {
          yield AnnouncementLoadSuccess(announcement);
        }
      } catch (error) {
        print(error);
        yield AnnouncementLoadFailure();
      }
    }
    if (event is NewAnnouncementLoad) {
      yield LoadingAnnouncement();
      try {
        final newAnnouncement = await announcementRepository.getNewesetAnnouncement();

        if (newAnnouncement != null) {
          yield NewAnnouncementLoadSuccess(newAnnouncement);
        }
      } catch (error) {
        print(error);
        yield NewAnnouncementLoadFailure();
      }
    }
  }
}

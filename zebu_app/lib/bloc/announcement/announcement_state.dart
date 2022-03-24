import 'package:zebu_app/models/announcement.dart';
import 'package:equatable/equatable.dart';

class AnnouncementState extends Equatable {
  const AnnouncementState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class Loading extends AnnouncementState {}


class AnnouncementsLoadSuccess extends AnnouncementState {
  final List<dynamic> announcements;

  const AnnouncementsLoadSuccess([this.announcements = const []]);

  @override
  List<Object> get props => [announcements];
}

class AnnouncementsLoadFailure extends AnnouncementState {}

class AnnouncementsEmpltyFailure extends AnnouncementState {
  final String message;

  const AnnouncementsEmpltyFailure({required this.message});
}

class AnnouncementLoadSuccess extends AnnouncementState {
  final Announcement announcement;

  const AnnouncementLoadSuccess(this.announcement);

  @override
  List<Object> get props => [announcement];
}

class AnnouncementLoadFailure extends AnnouncementState {}

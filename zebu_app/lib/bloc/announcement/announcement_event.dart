import 'package:zebu_app/models/announcement.dart';
import 'package:equatable/equatable.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();
}

class AnnouncementsLoad extends AnnouncementEvent {
  const AnnouncementsLoad();

  @override
  List<Object> get props => [];
}

class AnnouncementLoad extends AnnouncementEvent {
  final String id;
  const AnnouncementLoad(this.id);

  @override
  List<Object> get props => [];
}


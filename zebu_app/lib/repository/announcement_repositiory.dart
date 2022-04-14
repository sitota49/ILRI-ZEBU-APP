import 'package:zebu_app/models/announcement.dart';
import 'package:zebu_app/data_provider/announcement_data.dart';

class AnnouncementRepository {
  final AnnouncementDataProvider dataProvider;

  AnnouncementRepository({required this.dataProvider});

  Future<List<dynamic>> getAnnouncements() async {
    return await dataProvider.getAnnouncements();
  }

  Future<dynamic> getAnnouncement(String id) async {
    return await dataProvider.getAnnouncement(id);
  }

   Future<dynamic> getNewesetAnnouncement() async {
    return await dataProvider.getNewestAnnouncement();
  }

  
}

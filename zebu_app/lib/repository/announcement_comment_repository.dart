import 'package:zebu_app/data_provider/announcement_comment_data.dart';
import 'package:zebu_app/models/announcementComment.dart';

class AnnouncementCommentRepository {
  final AnnouncementCommentDataProvider dataProvider;

  AnnouncementCommentRepository({required this.dataProvider});

  Future<dynamic> createAnnouncementComment(
      AnnouncementComment announcementComment) async {
    return await dataProvider.createAnnouncementComment(announcementComment);
  }
}

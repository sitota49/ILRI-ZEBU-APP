import 'dart:convert';

import 'package:zebu_app/models/announcementComment.dart';
import 'package:http/http.dart' as http;

class AnnouncementCommentDataProvider {
  final http.Client httpClient;

  AnnouncementCommentDataProvider({required this.httpClient});

  Future<dynamic> createAnnouncementComment(AnnouncementComment announcementComment) async {
    final response = await httpClient.post(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/announcementcomment'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
        "data": {
          "type": "node--announcementcomment",
          "attributes": {
            "title": announcementComment.title,
            "field_booking_email": announcementComment.email,
            "field_comment": announcementComment.comment,
            "field_phone_number": announcementComment.phoneNo
          },
          "relationships": {
            "field_announcement": {
              "data": {
                "type": "node--announcement",
                "id": announcementComment.announcementId
              }
            }
          }
        }
      }),
    );

    if (response.statusCode == 201) {
      return 'Comment created';
    } else {
      throw Exception('Failed to create comment.');
    }
  }
}

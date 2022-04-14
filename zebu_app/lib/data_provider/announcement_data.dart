import 'dart:convert';
import 'dart:io';
import 'package:zebu_app/models/announcement.dart';
import 'package:http/http.dart' as http;

class AnnouncementDataProvider {
  final http.Client httpClient;

  AnnouncementDataProvider({required this.httpClient});

  Future<List<dynamic>> getAnnouncements() async {
    try {
      final response = await httpClient.get(
        Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/announcement'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<dynamic> jsonData = json['data'];
        return jsonData
            .map<Announcement>(
                (announcementData) => Announcement.fromJson(announcementData))
            .toList();
      } else {
        return ["No Announcements Found"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getAnnouncement(String id) async {
    final response = await httpClient.get(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/announcement/${id}'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Announcement.fromJson(json['data']);
    } else {
      throw Exception('Failed to load Announcement by Id');
    }
  }

  Future<dynamic> getNewestAnnouncement() async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/announcement?page[limit]=1&sort=-created'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Announcement.fromJson(json['data'][0]);
    } else {
      throw Exception('Failed to load newest Announcement');
    }
  }
}

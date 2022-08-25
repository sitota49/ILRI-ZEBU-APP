import 'dart:convert';

import 'package:zebu_app/models/feedback.dart';
import 'package:http/http.dart' as http;


class FeedbackDataProvider {
  final http.Client httpClient;

  FeedbackDataProvider({required this.httpClient});



  Future<dynamic> createFeedback(MyFeedBack feedback) async {
    final response = await httpClient.post(
      Uri.parse('https://zebuapp.ilri.org/jsonapi/node/feedback'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
        "data": {
    "type": "node--feedback",
    "attributes": {
      "title": feedback.title,
       "field_othercomment": feedback.otherComment,
        "field_booking_email": feedback.email,
        "field_dineoften": feedback.dineOften,
        "field_englishcommunication": feedback.englishCommuincation,
        "field_facilityrating": feedback.faciltiyRating,
        "field_fooditemcomment": feedback.foodItemComment,
        "field_foodrating": feedback.foodRating,
        "field_improovewhat": feedback.improoveWhat,
        "field_menuadded": feedback.menuAdded,
        "field_menudidntmatch": feedback.menudidntMatch,
        "field_outstandingservice": feedback.outStandingService,
        "field_phone_number": feedback.phoneNo,
        "field_servicerating": feedback.serviceRating
    }
  }
      }),
    );

    if (response.statusCode == 201) {
      return 'Feedback created';
    } else {
      throw Exception('Failed to create feedback.');
    }
  }

  
  }

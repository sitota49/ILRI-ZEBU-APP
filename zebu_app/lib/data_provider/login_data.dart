import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zebu_app/models/zebuUser.dart';

class LoginDataProvider {
  final http.Client httpClient;

  LoginDataProvider({required this.httpClient});

  Future<dynamic> checkPhone(String phoneNumber) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'https://zebuapp.ilri.org/jsonapi/node/appuser?filter[field_phonenumber]=${phoneNumber.substring(1)}'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var user = ZebuUser.fromJson(json['data'][0]);
        if (user != null) {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> checkEmail(String email) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'https://zebuapp.ilri.org/jsonapi/node/appuser?filter[field_email]=$email'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var user = ZebuUser.fromJson(json['data']);
        if (user != null) {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

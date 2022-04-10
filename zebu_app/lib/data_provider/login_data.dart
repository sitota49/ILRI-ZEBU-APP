import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zebu_app/models/zebuUser.dart';

class LoginDataProvider {
  final http.Client httpClient;

  LoginDataProvider({required this.httpClient});

  Future<dynamic> checkPhone(String phoneNumber) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/appuser?filter[field_phonenumber]=${phoneNumber}'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ZebuUser.fromJson(json['data']);
      } else {
        return 'User not found!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> checkEmail(String email) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/appuser?filter[field_email]=${email}'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ZebuUser.fromJson(json['data']);
      } else {
        return 'User not found!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

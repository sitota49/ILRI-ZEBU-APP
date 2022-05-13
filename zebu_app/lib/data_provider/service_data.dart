import 'dart:convert';
import 'package:zebu_app/models/service.dart';
import 'package:http/http.dart' as http;

class ServiceDataProvider {
  final http.Client httpClient;

  ServiceDataProvider({required this.httpClient});

  Future<List<dynamic>> getAllService() async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/service?_format=json'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/vnd.api+json',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var service = json
            .map<Service>((serviceData) => Service.fromJson(serviceData))
            .toList();

        return service;
      } else {
        return ["No Service Items Found"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

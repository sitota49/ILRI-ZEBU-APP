import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/models/menu.dart';
import 'package:http/http.dart' as http;

class MenuDataProvider {
  final http.Client httpClient;

  MenuDataProvider({required this.httpClient});

  Future<List<dynamic>> getAllMenu(queryParam) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/menu/search?title=${queryParam}&_format=json'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/vnd.api+json',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var menu =
            json.map<Menu>((menuData) => Menu.fromJson(menuData)).toList();

        // final SharedPreferences prefs = await SharedPreferences.getInstance();

        // var menuItemStringList = menu
        //     .map((menuItem) => {
        //           menuItem.toString(),
        //         })
        //     .toList();

        // var encoded = jsonEncode(menuItemStringList);
        // var decoded = jsonDecode(encoded);
        // var result =
        //     decoded.map<Menu>((menuData) => Menu.fromJson(menuData)).toList();

        // print(result);

        return menu;
      } else {
        return ["No Menu Items Found"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getCategoryMenu(String id) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/menu/${id}?_format=json'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Menu>((menuData) => Menu.fromJson(menuData)).toList();
    } else {
      return ["No Menu Items Found"];
    }
  }

  Future<dynamic> getSingleMenu(String id) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/menu/${id}?_format=json'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return Menu.fromJson(json[0]);
    } else {
      return ["No Menu Items Found"];
    }
  }
}

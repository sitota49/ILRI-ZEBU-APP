import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/models/order.dart';
import 'package:http/http.dart' as http;

class OrderDataProvider {
  final http.Client httpClient;

  OrderDataProvider({required this.httpClient});

  Future<dynamic> createOrder(Order order) async {
    final response = await httpClient.post(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/order'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
        "data": {
          "type": "node--order",
          "attributes": {
            "title": order.title,
            "field_date": order.date,
            "field_email": order.email,
            "field_phone_number": order.phoneNo,
            "field_qty": int.parse(order.qty!),
            "field_time": order.time
          },
          "relationships": {
            "field_item": {
              "data": {"type": "node--menu", "id": order.item}
            }
          }
        }
      }),
    );

    if (response.statusCode == 201) {
      return 'Order created';
    } else {
      throw Exception('Failed to create order.');
    }
  }

  Future<List<dynamic>> getOrdersByPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var fetchedUser = json.decode(prefs.getString('user')!);
      var phoneNo = fetchedUser['phoneNumber'];
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/order/member?_format=json&phoneNo=$phoneNo'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/vnd.api+json',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json.length == 0) {
          return ["No Orders Found"];
        }
        var order =
            json.map<Order>((orderData) => Order.fromJson(orderData)).toList();

        return order;
      } else {
        return ["Failed loading"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> deleteOrder(String id) async {
    final response = await httpClient.delete(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/order/$id'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{}),
    );

    if (response.statusCode == 204) {
      return 'Order deleted';
    } else {
      throw Exception('Failed to delete order.');
    }
  }
}

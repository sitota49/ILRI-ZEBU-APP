import 'dart:convert';
import 'package:zebu_app/models/booking.dart';
import 'package:http/http.dart' as http;

class BookingDataProvider {
  final http.Client httpClient;

  BookingDataProvider({required this.httpClient});

  Future<List<dynamic>> getAllBooking() async {
    try {
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/booking?_format=json'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/vnd.api+json',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        var booking = json
            .map<Booking>((bookingData) => Booking.fromJson(bookingData))
            .toList();

        return booking;
      } else {
        return ["No Booking Items Found"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

   Future<dynamic> getServiceBooking(String service) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/booking/service?service=$service&_format=json'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json.map<Booking>((bookingData) => Booking.fromJson(bookingData)).toList();
    } else {
      return ["No Menu Items Found"];
    }
  }

  
}

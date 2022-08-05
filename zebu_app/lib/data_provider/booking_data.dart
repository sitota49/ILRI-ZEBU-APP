import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zebu_app/models/booking.dart';
import 'package:http/http.dart' as http;
import 'package:zebu_app/models/serviceDetail.dart';

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

  Future<dynamic> getServiceBooking(String service, String date) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/booking/service?service="$service"&date=$date&_format=json'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json
          .map<Booking>((bookingData) => Booking.fromJson(bookingData))
          .toList();
    } else {
      return ["No Menu Items Found"];
    }
  }

  Future<dynamic> getServiceDetail(String serviceDetail) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/servicedetail?_format=json&serviceDetail=$serviceDetail'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ServiceDetail.fromJson(json[0]);
    } else {
      return ["No Items Found"];
    }
  }

  Future<dynamic> createBooking(Booking booking) async {
    final response = await httpClient.post(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/booking'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
        'data': {
          "type": "node--booking",
          "attributes": {
            "title": booking.title,
            "field_date": booking.date,
            "field_booking_email": booking.email,
            "field_phone_number": booking.phoneNo,
            "field_service_type": booking.serviceType,
            "field_time": booking.time
          }
        }
      }),
    );

    if (response.statusCode == 201) {
      return 'Booking created';
    } else {
      throw Exception('Failed to create booking.');
    }
  }

  Future<List<dynamic>> getBookingsByPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var fetchedUser = json.decode(prefs.getString('user')!);
      var phoneNo = fetchedUser['phoneNumber'];
      final response = await httpClient.get(
        Uri.parse(
            'http://45.79.249.127/zebuapi/jsonapi/node/booking/member?_format=json&phoneNo=$phoneNo'),
        headers: <String, String>{
          'Accept': 'application/vnd.api+json',
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/vnd.api+json',
          'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if(json.length == 0){
          return ["No Booking Items Found"];
        }
        var booking = json
            .map<Booking>((bookingData) => Booking.fromJson(bookingData))
            .toList();

        return booking;
      } else {
        return ["Failed loading"];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> deleteBooking(String id) async {
    final response = await httpClient.delete(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/booking/$id'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
     
      }),
    );

    if (response.statusCode == 204) {
      return 'Booking deleted';
    } else {
      throw Exception('Failed to delete booking.');
    }
  }

  Future<dynamic> getSingleBooking(String id) async {
    final response = await httpClient.get(
      Uri.parse(
          'http://45.79.249.127/zebuapi/jsonapi/node/booking/$id?_format=json'),
      headers: <String, String>{
        'Accept': 'application/vnd.api+json',
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Headers': 'Access-Control-Allow-Origin, Accept'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Booking.fromJson(json[0]);
    } else {
      return ["No Booking Items Found"];
    }
  }

  Future<dynamic> updateBooking(Booking booking) async {
    var id = booking.id;
    final response = await httpClient.patch(
      Uri.parse('http://45.79.249.127/zebuapi/jsonapi/node/booking/$id'),
      headers: <String, String>{
        'Content-Type': 'application/vnd.api+json',
        'Accept': 'application/vnd.api+json',
        'Authorization': 'Basic QWRtaW46QWRtaW5AMTIzNDU2'
      },
      body: jsonEncode(<String, dynamic>{
        "data": {
          "type": "node--booking",
          "id": booking.id,
          "attributes": {"field_date": booking.date, "field_time": booking.time}
        }
      }),
    );

    if (response.statusCode == 200) {
      return 'Booking updated';
    } else {
      throw Exception('Failed to update booking.');
    }
  }
}

import 'package:zebu_app/data_provider/booking_data.dart';

class BookingRepository {
  final BookingDataProvider dataProvider;

  BookingRepository({required this.dataProvider});

  Future<List<dynamic>> getAllBooking() async {
    return await dataProvider.getAllBooking();
  }

  Future<dynamic> getServiceBooking(String service, String date) async {
    return await dataProvider.getServiceBooking(service, date);
  }

   Future<dynamic> getServiceDetail(String serviceDetail) async {
    return await dataProvider.getServiceDetail(serviceDetail);
  }
}

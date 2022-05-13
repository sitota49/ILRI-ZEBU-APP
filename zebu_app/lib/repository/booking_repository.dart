import 'package:zebu_app/data_provider/booking_data.dart';

class BookingRepository {
  final BookingDataProvider dataProvider;

  BookingRepository({required this.dataProvider});

  Future<List<dynamic>> getAllBooking() async {
    return await dataProvider.getAllBooking();
  }

  Future<dynamic> getServiceBooking(String service) async {
    return await dataProvider.getServiceBooking(service);
  }
}

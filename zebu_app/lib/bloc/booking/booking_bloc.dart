
import 'package:zebu_app/bloc/booking/booking_event.dart';
import 'package:zebu_app/bloc/booking/booking_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/repository/booking_repository.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(LoadingBooking());

  @override
  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is ServiceBookingLoad) {
      yield LoadingBooking();
      try {
        final serviceBookings =
            await bookingRepository.getServiceBooking(event.service);

        yield ServiceBookingLoadSuccess(serviceBookings);
      } catch (error) {
        print(error);
        yield ServiceBookingLoadFailure();
      }
    }
  }
}

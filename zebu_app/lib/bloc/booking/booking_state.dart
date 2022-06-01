import 'package:equatable/equatable.dart';

class BookingState extends Equatable {
  const BookingState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingBooking extends BookingState {}

class ServiceBookingLoadSuccess extends BookingState {
  final List<dynamic> serviceBookings;
  final dynamic serviceDetail;

  const ServiceBookingLoadSuccess([this.serviceBookings = const [], this.serviceDetail]);

  @override
  List<Object> get props => [serviceBookings];
}

class ServiceBookingLoadFailure extends BookingState {}

class ServiceBookingEmpltyFailure extends BookingState {
  final String message;

  const ServiceBookingEmpltyFailure({required this.message});
}

class ServiceDetailLoadSuccess extends BookingState {
  final dynamic serviceDetail;

  const ServiceDetailLoadSuccess([this.serviceDetail = const []]);

  @override
  List<Object> get props => [serviceDetail];
}

class ServiceDetailLoadFailure extends BookingState {}

class BookingSuccess extends BookingState {
  @override
  List<Object> get props => [];
}

class BookingFailure extends BookingState {
  @override
  List<Object> get props => [];
}

class MyBookingsLoadSuccess extends BookingState {
  final List<dynamic> myBookings;


  const MyBookingsLoadSuccess(
      [this.myBookings = const []]);

  @override
  List<Object> get props => [myBookings];
}

class MyBookingsLoadFailure extends BookingState {}

class MyBookingsEmpltyFailure extends BookingState {
  final String message;

  const MyBookingsEmpltyFailure({required this.message});
}

class DeleteBookingSuccess extends BookingState {
  @override
  List<Object> get props => [];
}

class DeleteBookingFailure extends BookingState {
  @override
  List<Object> get props => [];
}
class SingleBookingLoadSuccess extends BookingState {
  final dynamic singleBooking;

  const SingleBookingLoadSuccess([this.singleBooking = const []]);

  @override
  List<Object> get props => [singleBooking];
}

class SingleBookingLoadFailure extends BookingState {}

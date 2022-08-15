import 'package:equatable/equatable.dart';

class DiningBookingState extends Equatable {
  const DiningBookingState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingBooking extends DiningBookingState {}

class ServiceBookingLoadSuccess extends DiningBookingState {
  final List<dynamic> serviceBookings;
  final dynamic serviceDetail;

  const ServiceBookingLoadSuccess([this.serviceBookings = const [], this.serviceDetail]);

  @override
  List<Object> get props => [serviceBookings];
}

class ServiceBookingLoadFailure extends DiningBookingState {}

class ServiceBookingEmpltyFailure extends DiningBookingState {
  final String message;

  const ServiceBookingEmpltyFailure({required this.message});
}

class ServiceDetailLoadSuccess extends DiningBookingState {
  final dynamic serviceDetail;

  const ServiceDetailLoadSuccess([this.serviceDetail = const []]);

  @override
  List<Object> get props => [serviceDetail];
}

class ServiceDetailLoadFailure extends DiningBookingState {}

class BookingSuccess extends DiningBookingState {
  @override
  List<Object> get props => [];
}

class BookingFailure extends DiningBookingState {
  @override
  List<Object> get props => [];
}


class UpdateBookingSuccess extends DiningBookingState {
  @override
  List<Object> get props => [];
}

class UpdateBookingFailure extends DiningBookingState {
  @override
  List<Object> get props => [];
}

class MyBookingsLoadSuccess extends DiningBookingState {
  final List<dynamic> myBookings;


  const MyBookingsLoadSuccess(
      [this.myBookings = const []]);

  @override
  List<Object> get props => [myBookings];
}

class MyBookingsLoadFailure extends DiningBookingState {}

class MyBookingsEmpltyFailure extends DiningBookingState {
  final String message;

  const MyBookingsEmpltyFailure({required this.message});
}

class DeleteBookingSuccess extends DiningBookingState {
  @override
  List<Object> get props => [];
}

class DeleteBookingFailure extends DiningBookingState {
  @override
  List<Object> get props => [];
}
class SingleBookingLoadSuccess extends DiningBookingState {
  final dynamic singleBooking;

  const SingleBookingLoadSuccess([this.singleBooking = const []]);

  @override
  List<Object> get props => [singleBooking];
}

class SingleBookingLoadFailure extends DiningBookingState {}

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


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

  const ServiceBookingLoadSuccess([this.serviceBookings = const []]);

  @override
  List<Object> get props => [serviceBookings];
}

class ServiceBookingLoadFailure extends BookingState {}

class ServiceBookingEmpltyFailure extends BookingState {
  final String message;

  const ServiceBookingEmpltyFailure({required this.message});
}


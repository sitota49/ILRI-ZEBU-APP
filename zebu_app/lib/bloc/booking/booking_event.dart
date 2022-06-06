import 'package:equatable/equatable.dart';
import 'package:zebu_app/models/booking.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
}

class ServiceBookingLoad extends BookingEvent {
  final String service;
  final String date;
  final String serviceDetail;
  const ServiceBookingLoad(this.service, this.date, this.serviceDetail);

  @override
  List<Object> get props => [];
}

class Book extends BookingEvent {
  final Booking booking;
  const Book(this.booking);

  List<Object?> get props => [];
}

class UpdateBooking extends BookingEvent {
  final Booking bookingUpdate;
  const UpdateBooking(this.bookingUpdate);

  List<Object?> get props => [];
}

class MyBookingsLoad extends BookingEvent {
  const MyBookingsLoad();

  @override
  List<Object> get props => [];
}

class DeleteBooking extends BookingEvent {
  final String id;
  const DeleteBooking(this.id);

  List<Object?> get props => [];
}

class SingleBookingLoad extends BookingEvent {
  final String id;
  const SingleBookingLoad(this.id);

  @override
  List<Object> get props => [];
}

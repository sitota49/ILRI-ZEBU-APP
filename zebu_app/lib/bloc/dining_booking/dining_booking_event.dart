import 'package:equatable/equatable.dart';
import 'package:zebu_app/models/booking.dart';

abstract class DiningBookingEvent extends Equatable {
  const DiningBookingEvent();
}

class ServiceBookingLoad extends DiningBookingEvent {
  final String service;
  final String date;
  final String serviceDetail;
  const ServiceBookingLoad(this.service, this.date, this.serviceDetail);

  @override
  List<Object> get props => [];
}

class Book extends DiningBookingEvent {
  final Booking booking;
  const Book(this.booking);

  List<Object?> get props => [];
}

class UpdateBooking extends DiningBookingEvent {
  final Booking bookingUpdate;
  const UpdateBooking(this.bookingUpdate);

  List<Object?> get props => [];
}

class MyBookingsLoad extends DiningBookingEvent {
  const MyBookingsLoad();

  @override
  List<Object> get props => [];
}

class DeleteBooking extends DiningBookingEvent {
  final String id;
  const DeleteBooking(this.id);

  List<Object?> get props => [];
}

class SingleBookingLoad extends DiningBookingEvent {
  final String id;
  const SingleBookingLoad(this.id);

  @override
  List<Object> get props => [];
}

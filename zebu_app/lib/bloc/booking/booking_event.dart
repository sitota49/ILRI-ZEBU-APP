
import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
}

class ServiceBookingLoad extends BookingEvent {
 final String service;
  const ServiceBookingLoad(this.service);

  @override
  List<Object> get props => [];
}

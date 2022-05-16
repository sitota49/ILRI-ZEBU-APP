import 'package:equatable/equatable.dart';

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

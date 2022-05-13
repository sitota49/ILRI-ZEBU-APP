class Booking {
  final String id;
  final String? title;
  final String? date;
  final String? email;
  final String? time;
  final String? serviceType;
  final String? phoneNo;


  Booking(
      {required this.id,
      required this.title,
      this.date,
      this.email,
      this.time,
    this.serviceType,
    this.phoneNo, 
      });

  @override
  List<Object?> get props => [id, title, date, email, phoneNo, serviceType, time];
  factory Booking.fromJson(Map<String, dynamic> json) {
    var booking = Booking(
      title: json['title'],
      id: json['uuid'],
      date: json['field_date'] == '' ? null : json['field_date'],
      email: json['field_booking_email'] == '' ? null : json['field_booking_email'],
      phoneNo: json['field_phone_number'] == '' ? null : json['field_phone_number'],
      serviceType: json['field_service_type'] == '' ? null : json['field_service_type'],
      time: json['field_time'] == '' ? null : json['field_time'],

      
    );

    return booking;
  }

  @override
  String toString() =>
      'Booking {id: $id , title: $title, email: $email, phoneNo:$phoneNo, date:$date, time: $time, serviceType:$serviceType}';
}

class Booking {
  final String? id;
  final String? title;
  final String? date;
  final String? email;
  final String? time;
  final String? serviceType;
  final String? phoneNo;
  final String? guestNames;
  final String? noOfGuests;
  final String? staffComment;

  Booking({
    this.id,
    required this.title,
    this.date,
    this.email,
    this.time,
    this.serviceType,
    this.phoneNo,
    this.guestNames,
    this.noOfGuests,
    this.staffComment,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        email,
        phoneNo,
        serviceType,
        time,
        guestNames,
        noOfGuests,
        staffComment
      ];
  factory Booking.fromJson(Map<String, dynamic> json) {
    var booking = Booking(
      title: json['title'],
      id: json['uuid'],
      date: json['field_date'] == '' ? null : json['field_date'],
      email: json['field_booking_email'] == ''
          ? null
          : json['field_booking_email'],
      phoneNo:
          json['field_phone_number'] == '' ? null : json['field_phone_number'],
      serviceType:
          json['field_service_type'] == '' ? null : json['field_service_type'],
      time: json['field_time'] == '' ? null : json['field_time'],
      guestNames:
          json['field_guest_names'] == '' ? null : json['field_guest_names'],
      noOfGuests:
          json['field_no_of_guests'] == '' ? null : json['field_no_of_guests'],
      staffComment: json['field_staffreview'] == ''
          ? null
          : json['field_staffreview'],
    );

    return booking;
  }

  @override
  String toString() =>
      'Booking {id: $id , title: $title, email: $email, phoneNo:$phoneNo, date:$date, time: $time, serviceType:$serviceType, guestNames:$guestNames, noOfguests:$noOfGuests, staffComment:$staffComment}';
}

class Order {
  final String? id;
  final String? title;
  final String? date;
  final String? email;
  final String? time;
  final String? item;
  final String? phoneNo;
  final String? qty;
  final String? isDelivered;


  Order( {
    this.id,
    required this.title,
    this.date,
    this.email,
    this.time,
    this.item,
    this.phoneNo,
    this.qty,
    this.isDelivered,
    
  });

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        email,
        phoneNo,
        item,
        time,
        qty,
        isDelivered,
       
      ];
  factory Order.fromJson(Map<String, dynamic> json) {
    var order = Order(
      title: json['title'],
      id: json['uuid'],
      date: json['field_date'] == '' ? null : json['field_date'],
      email: json['field_Order_email'] == ''
          ? null
          : json['field_Order_email'],
      phoneNo:
          json['field_phone_number'] == '' ? null : json['field_phone_number'],
      item:
          json['field_item'] == '' ? null : json['field_item'],
      time: json['field_time'] == '' ? null : json['field_time'],
      isDelivered:
          json['field_isdelivered'] == '' ? null : json['field_isdelivered'],
      qty:
          json['field_qty'] == '' ? null : json['field_qty'],
     
    );

    return order;
  }

  @override
  String toString() =>
      'Order {id: $id , title: $title, email: $email, phoneNo:$phoneNo, date:$date, time: $time, item:$item, isDelivered:$isDelivered, qty:$qty}';
}

import 'package:equatable/equatable.dart';
import 'package:zebu_app/models/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}



class PlaceOrder extends OrderEvent {
   final Order order;
  const PlaceOrder(this.order);

  List<Object?> get props => [];
}



class MyOrdersLoad extends OrderEvent {
  const MyOrdersLoad();

  @override
  List<Object> get props => [];
}

class DeleteOrder extends OrderEvent {
  final String id;
  const DeleteOrder(this.id);

  List<Object?> get props => [];
}

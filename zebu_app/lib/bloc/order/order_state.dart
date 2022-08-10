import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  const OrderState();
  final String failureMessage = "Failed to load";
  @override
  List<Object> get props => [];
}

class LoadingOrder extends OrderState {}


class OrderSuccess extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderFailure extends OrderState {
  @override
  List<Object> get props => [];
}




class MyOrdersLoadSuccess extends OrderState {
  final List<dynamic> myOrders;


  const MyOrdersLoadSuccess(
      [this.myOrders = const []]);

  @override
  List<Object> get props => [myOrders];
}

class MyOrdersLoadFailure extends OrderState {}

class MyOrdersEmpltyFailure extends OrderState {
  final String message;

  const MyOrdersEmpltyFailure({required this.message});
}

class DeleteOrderSuccess extends OrderState {
  @override
  List<Object> get props => [];
}

class DeleteOrderFailure extends OrderState {
  @override
  List<Object> get props => [];
}

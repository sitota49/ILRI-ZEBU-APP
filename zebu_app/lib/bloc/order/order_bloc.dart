import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zebu_app/bloc/order/order_event.dart';
import 'package:zebu_app/bloc/order/order_state.dart';

import 'package:zebu_app/repository/order_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(LoadingOrder());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is PlaceOrder) {
      yield LoadingOrder();
      try {
        final status = await orderRepository.createOrder(event.order);
        if (status == 'Order created') {
          yield OrderSuccess();
        }
      } catch (error) {
        print(error);

        yield OrderFailure();
      }
    }

    if (event is MyOrdersLoad) {
      yield LoadingOrder();
      try {
        final myOrders = await orderRepository.getOrdersByPhone();

        if (myOrders[0] == "No Orders Found") {
          yield MyOrdersEmpltyFailure(message: "No Orders Found");
        } else if (myOrders[0] == "Failed loading") {
          yield MyOrdersLoadFailure();
        } else {
          yield MyOrdersLoadSuccess(myOrders);
        }
      } catch (error) {
        print(error);

        yield MyOrdersLoadFailure();
      }
    }

    if (event is DeleteOrder) {
      yield LoadingOrder();
      try {
        final status = await orderRepository.deleteOrder(event.id);
        if (status == 'Order deleted') {
          yield DeleteOrderSuccess();
        }
      } catch (error) {
        print(error);

        yield DeleteOrderFailure();
      }
    }
  }
}

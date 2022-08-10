import 'package:zebu_app/data_provider/order_data.dart';
import 'package:zebu_app/models/order.dart';

class OrderRepository {
  final OrderDataProvider dataProvider;

  OrderRepository({required this.dataProvider});

  Future<dynamic> createOrder(Order order) async {
    return await dataProvider.createOrder(order);
  }

  Future<List<dynamic>> getOrdersByPhone() async {
    return await dataProvider.getOrdersByPhone();
  }

  Future<dynamic> deleteOrder(String id) async {
    return await dataProvider.deleteOrder(id);
  }
}

import '../../model/orders/order_model.dart';
import '../../model/orders/order_status.dart';

abstract class OrderRepository {
Future<List<OrderModel>>findAllOrder(DateTime date,[OrderStatus? status]);
Future<OrderModel>getById(int id);
Future<void>changeStatus(int id,OrderStatus status);
}
import '../../dto/order/order_dto.dart';
import '../../model/orders/order_model.dart';

abstract class GetOrderById {
Future<OrderDto>call(OrderModel order);
}
import '../../dto/order/order_dto.dart';
import '../../dto/order/order_product_dto.dart';
import '../../model/orders/order_model.dart';
import '../../model/payment_type_model.dart';
import '../../model/user_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
import '../../repositories/products/products_repository.dart';
import '../../repositories/user/user_repository.dart';
import './get_order_by_id.dart';

class GetOrderByIdImpl implements GetOrderById {
  final PaymentTypeRepository _paymentTypeRepository;
  final UserRepository _userRepository;
  final ProductsRepository _productsRepository;

  GetOrderByIdImpl(
    this._paymentTypeRepository,
    this._userRepository,
    this._productsRepository,
  );
  @override
  Future<OrderDto> call(OrderModel order) => _orderDtoParse(order);

  Future<OrderDto> _orderDtoParse(OrderModel order) async {
    final paymentTypeFuture =
        _paymentTypeRepository.getById(order.paymentTypeId);
    final userFuture = _userRepository.getById(order.id);
    final orderProductsFuture = _orderProductParse(order);
    final responses = await Future.wait([
      paymentTypeFuture,
      userFuture,
      orderProductsFuture,
    ]);
    return OrderDto(
      id: order.id,
      date: order.date,
      status: order.status,
      orderProducts: responses[2] as List<OrderProductDto>,
      user: responses[1] as UserModel,
      address: order.address,
      cpf: order.cpf,
      paymentTypeModel: responses[0] as PaymentTypeModel,
    );
  }

  Future<List<OrderProductDto>> _orderProductParse(OrderModel order) async {
    final orderProducts = <OrderProductDto>[];

    final productsFuture = order.orderProducts
        .map((e) => _productsRepository.getProduct(e.productId))
        .toList();
    final products = await Future.wait(productsFuture);

    for (var i = 0; i < order.orderProducts.length; i++) {
      final orderProduct = order.orderProducts[i];
      final productDto = OrderProductDto(
        product: products[i],
        amount: orderProduct.amount,
        totalPrice: orderProduct.totalPrice,
      );
      orderProducts.add(productDto);
    }
    return orderProducts;
  }
}

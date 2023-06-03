import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../dto/order/order_dto.dart';
import '../../model/orders/order_model.dart';
import '../../model/orders/order_status.dart';
import '../../repositories/order/order_repository.dart';
import '../../service/order/get_order_by_id.dart';
part 'order.controller.g.dart';

enum OrderStateStatus {
  initial,
  loading,
  loaded,
  error,
  showDetailsModal,
  statusChanged,
}

class OrderController = OrderControllerBase with _$OrderController;

abstract class OrderControllerBase with Store {
  final OrderRepository _orderRepository;
  final GetOrderById _getOrderById;

  @readonly
  var _status = OrderStateStatus.initial;

  @readonly
  String? _errorMessage;

  late final DateTime _today;

  @readonly
  OrderStatus? _statusFilter;

  @readonly
  var _orders = <OrderModel>[];

  @readonly
  OrderDto? _orderSelected;

  OrderControllerBase(this._orderRepository, this._getOrderById) {
    final todayNow = DateTime.now();
    _today = DateTime(todayNow.year, todayNow.month, todayNow.day);
  }
  @action
  Future<void> changeStatusFilter(OrderStatus? status) async {
    _statusFilter = status;
    findOrders();
  }

  @action
  Future<void> findOrders() async {
    try {
      _status = OrderStateStatus.loading;
      _orders = await _orderRepository.findAllOrder(_today, _statusFilter);
      _status = OrderStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar pedidos do dia', error: e, stackTrace: s);
      _errorMessage = 'Erro ao buscar pedidos do dia';
      _status = OrderStateStatus.error;
    }
  }

  @action
  Future<void> showDetailModal(OrderModel order) async {
    _status = OrderStateStatus.loading;
    _orderSelected = await _getOrderById(order);
    _status = OrderStateStatus.showDetailsModal;
  }

  @action
  Future<void> changeStatus(OrderStatus status) async {
    _status = OrderStateStatus.loading;
    await _orderRepository.changeStatus(_orderSelected!.id, status);
    _status = OrderStateStatus.statusChanged;
  }
}

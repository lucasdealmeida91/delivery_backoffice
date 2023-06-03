import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_excception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../model/orders/order_model.dart';
import '../../model/orders/order_status.dart';
import './order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final CustomDio _dio;

  OrderRepositoryImpl(this._dio);
  @override
  Future<void> changeStatus(int id, OrderStatus status) async {
    try {
      await _dio.auth().put('/orders/$id', data: {'status': status.acronym});
    } on DioError catch (e, s) {
      log(
        'Erro ao alterar status do pedido para ${status.acronym}',
        error: e,
        stackTrace: s,
      );
      throw RepositoryExcception(
          message: 'Erro ao alterar status do pedido para ${status.acronym}');
    }
  }

  @override
  Future<List<OrderModel>> findAllOrder(DateTime date,
      [OrderStatus? status]) async {
    try {
      final orderResponse = await _dio.auth().get(
        '/orders',
        queryParameters: {
          'date': date.toIso8601String(),
          if (status != null) 'status': status.acronym
        },
      );
      return orderResponse.data
          .map<OrderModel>((order) => OrderModel.fromMap(order))
          .toList();
    } on DioError catch (e, s) {
      log(
        'Erro ao buscar  pedidos}',
        error: e,
        stackTrace: s,
      );
      throw RepositoryExcception(
        message: 'Erro ao buscar pedidos',
      );
    }
  }

  @override
  Future<OrderModel> getById(int id) async {
    try {
      final orderResponse = await _dio.auth().get(
            '/orders/$id',
          );
      return OrderModel.fromMap(orderResponse.data);
    } on DioError catch (e, s) {
      log(
        'Erro ao buscar pedido}',
        error: e,
        stackTrace: s,
      );
      throw RepositoryExcception(
        message: 'Erro ao buscar pedido',
      );
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_excception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../model/payment_type_model.dart';
import './payment_type_repository.dart';

class PaymentTypeRepositoryImpl implements PaymentTypeRepository {
  final CustomDio _dio;

  PaymentTypeRepositoryImpl(this._dio);
  @override
  Future<List<PaymentTypeModel>> findAll(bool? enabled) async {
    try {
      final paymentResult = await _dio.auth().get(
        '/payment-types',
        queryParameters: {if (enabled != null) 'enabled': enabled},
      );
      return paymentResult.data
          .map<PaymentTypeModel>(
            (model) => PaymentTypeModel.fromMap(model),
          )
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar formas de pagamento', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao buscar formas de pagamento');
    }
  }

  @override
  Future<PaymentTypeModel> getById(int id) async {
    try {
      final paymentResult = await _dio.auth().get(
            '/payment-types/$id',
          );
      return PaymentTypeModel.fromMap(paymentResult.data);
    } on DioError catch (e, s) {
      log('Erro ao buscar forma de pagamento $id', error: e, stackTrace: s);
      throw RepositoryExcception(
          message: 'Erro ao buscar forma de pagamento com id: $id');
    }
  }

  @override
  Future<void> save(PaymentTypeModel model) async {
    try {
      final client = _dio.auth();

      if (model.id != null) {
        await client.put(
          '/payment-types/${model.id}',
          data: model.toMap(),
        );
      } else {
        await client.post(
          '/payment-types',
          data: model.toMap(),
        );
      }
    } on DioError catch (e, s) {
      log('Erro ao slavar forma de pagamento', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao salvar forma de pagamento');
    }
  }
}

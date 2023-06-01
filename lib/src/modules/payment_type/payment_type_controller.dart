import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../model/payment_type_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';

part 'payment_type_controller.g.dart';

enum PaymentTypeStateStatus {
  initial,
  loading,
  loaded,
  error;
}

class PaymentTypeController = _PaymentTypeControllerBase
    with _$PaymentTypeController;

abstract class _PaymentTypeControllerBase with Store {
  @readonly
  var _status = PaymentTypeStateStatus.initial;

  @readonly
  var _paymentTypes = <PaymentTypeModel>[];

  @readonly
  String? _errorMessage;

  final PaymentTypeRepository _paymentTypeRepository;

  _PaymentTypeControllerBase(this._paymentTypeRepository);

  @action
  Future<void> loadPayments() async {
    try {
      _status = PaymentTypeStateStatus.loading;
      _paymentTypes = await _paymentTypeRepository.findAll(null);
      _status = PaymentTypeStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao carregar as formas de pagamento', error: e, stackTrace: s);
      _errorMessage ='Erro ao carregar as formas de pagamento' ;
      _status = PaymentTypeStateStatus.error;
    }
  }
}

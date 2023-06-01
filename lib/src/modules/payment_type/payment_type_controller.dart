import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../model/payment_type_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';

part 'payment_type_controller.g.dart';

enum PaymentTypeStateStatus {
  initial,
  loading,
  loaded,
  error,
  addOrUpdatePayment,
  saved;
}

class PaymentTypeController = _PaymentTypeControllerBase
    with _$PaymentTypeController;

abstract class _PaymentTypeControllerBase with Store {
  @readonly
  var _status = PaymentTypeStateStatus.initial;

  @readonly
  bool? _filterEnabled;

  @readonly
  var _paymentTypes = <PaymentTypeModel>[];

  @readonly
  String? _errorMessage;
  @readonly
  PaymentTypeModel? _paymentTypeSelected;

  final PaymentTypeRepository _paymentTypeRepository;

  _PaymentTypeControllerBase(this._paymentTypeRepository);

  @action
  void changeFilter(bool? enabled) => _filterEnabled = enabled;

  @action
  Future<void> loadPayments() async {
    try {
      _status = PaymentTypeStateStatus.loading;
      _paymentTypes = await _paymentTypeRepository.findAll(_filterEnabled);
      _status = PaymentTypeStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao carregar as formas de pagamento', error: e, stackTrace: s);
      _errorMessage = 'Erro ao carregar as formas de pagamento';
      _status = PaymentTypeStateStatus.error;
    }
  }

  @action
  Future<void> addPayment() async {
    _status = PaymentTypeStateStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = null;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> editPayment(PaymentTypeModel payment) async {
    _status = PaymentTypeStateStatus.loading;
    await Future.delayed(Duration.zero);
    _paymentTypeSelected = payment;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> savePayment({
    int? id,
    required String name,
    required String acronym,
    required bool enabled,
  }) async {
    try {
  _status= PaymentTypeStateStatus.loading;
  final paymentTypeModel = PaymentTypeModel(
    id: id,
    name: name,
    acronym: acronym,
    enabled: enabled,
  );
  _paymentTypeRepository.save(paymentTypeModel);
  _status= PaymentTypeStateStatus.saved;
} catch (e,s) {
  
}

  }
}

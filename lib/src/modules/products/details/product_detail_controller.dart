import 'dart:developer';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';

import '../../../model/product_model.dart';
import '../../../repositories/products/products_repository.dart';
part 'product_detail_controller.g.dart';

enum ProductsDetailStateStatus {
  initial,
  loading,
  loaded,
  error,
  errorLoadProduct,
  deleted,
  uploaded,
  saved,
}

class ProductDetailController = ProductDetailControllerBase
    with _$ProductDetailController;

abstract class ProductDetailControllerBase with Store {
  final ProductsRepository _productsRepository;

  @readonly
  var _status = ProductsDetailStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  String? _imagePath;

  ProductDetailControllerBase(this._productsRepository);
  @action
  Future<void> uploadImageProduct(Uint8List file, String filename) async {
    _status = ProductsDetailStateStatus.loading;
    _imagePath = await _productsRepository.uploadImageProduct(file, filename);
    _status = ProductsDetailStateStatus.uploaded;
  }

  Future<void> save(String name, double price, String description) async {
    try {
      _status = ProductsDetailStateStatus.loading;
      final productModel = ProductModel(
        name: name,
        description: description,
        price: price,
        image: _imagePath!,
        enabled: true,
      );
      await _productsRepository.save(productModel);
      _status = ProductsDetailStateStatus.saved;
    } catch (e, s) {
      _errorMessage = 'Erro ao salvar produto';
      _status = ProductsDetailStateStatus.error;
      log('Erro ao salvar produto', error: e, stackTrace: s);
    }
  }
}

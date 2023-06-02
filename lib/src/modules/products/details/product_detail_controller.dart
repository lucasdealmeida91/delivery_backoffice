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

  @readonly
  ProductModel? _productModel;

  ProductDetailControllerBase(this._productsRepository);
  @action
  Future<void> uploadImageProduct(Uint8List file, String filename) async {
    _status = ProductsDetailStateStatus.loading;
    _imagePath = await _productsRepository.uploadImageProduct(file, filename);
    _status = ProductsDetailStateStatus.uploaded;
  }

  @action
  Future<void> save(String name, double price, String description) async {
    try {
      _status = ProductsDetailStateStatus.loading;
      final productModel = ProductModel(
        id: _productModel?.id,
        name: name,
        description: description,
        price: price,
        image: _imagePath!,
        enabled: _productModel?.enabled ?? true,
      );
      await _productsRepository.save(productModel);
      _status = ProductsDetailStateStatus.saved;
    } catch (e, s) {
      _errorMessage = 'Erro ao salvar produto';
      _status = ProductsDetailStateStatus.error;
      log('Erro ao salvar produto', error: e, stackTrace: s);
    }
  }

  Future<void> loadProduct(int? id) async {
    try {
      _status = ProductsDetailStateStatus.loading;
      _productModel = null;
      _imagePath = null;
      if (id != null) {
        _productModel = await _productsRepository.getProduct(id);
        _imagePath = _productModel!.image;
      }
      _status = ProductsDetailStateStatus.loaded;
    } catch (e, s) {
      _errorMessage = 'Erro ao carregar produto para alteração';
      _status = ProductsDetailStateStatus.errorLoadProduct;
      log('Erro ao carregar produto ', error: e, stackTrace: s);
    }
  }

  Future<void> deleteProduct() async {
    try {
      _status = ProductsDetailStateStatus.loading;
      if (_productModel != null && _productModel!.id != null) {
        await _productsRepository.deleteProduct(_productModel!.id!);
        _status = ProductsDetailStateStatus.deleted;
      } else {
        await Future.delayed(Duration.zero);
        _errorMessage =
            'Produto não cadastrado, não é possivel deletar o produto';
        _status = ProductsDetailStateStatus.error;
      }
    } catch (e, s) {
      _errorMessage = 'Erro ao deletar produto';
      _status = ProductsDetailStateStatus.error;
      log('Erro ao deletar produto ', error: e, stackTrace: s);
    }
  }
}

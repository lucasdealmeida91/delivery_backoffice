import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../../model/product_model.dart';
import '../../../repositories/products/products_repository.dart';
part 'products_controller.g.dart';

enum ProductsStateStatus { initial, loading, loaded, error, addOrUpdateProduct }

class ProductsController = ProductsControllerBase with _$ProductsController;

abstract class ProductsControllerBase with Store {
  final ProductsRepository _productsRepository;

  ProductsControllerBase(this._productsRepository);
  @readonly
  var _status = ProductsStateStatus.initial;

  @readonly
  var _products = <ProductModel>[];

  @readonly
  String? _filterName;
  @readonly
  ProductModel? _productSelected;

  @action
  Future<void> filterByName(String name) async {
    _filterName = name;
    await loadProducts();
  }

  @action
  Future<void> loadProducts() async {
    try {
      _status = ProductsStateStatus.loading;
      _products = await _productsRepository.findAll(_filterName);
      _status = ProductsStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      _status = ProductsStateStatus.error;
    }
  }

  Future<void> addProduct() async {
    _status = ProductsStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = null;
    _status = ProductsStateStatus.addOrUpdateProduct;
  }
   Future<void> editProduct(ProductModel productModel) async {
    _status = ProductsStateStatus.loading;
    await Future.delayed(Duration.zero);
    _productSelected = productModel;
    _status = ProductsStateStatus.addOrUpdateProduct;
  }
}

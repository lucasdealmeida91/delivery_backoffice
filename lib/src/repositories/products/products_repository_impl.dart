import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_excception.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../model/product_model.dart';
import 'dart:typed_data';

import './products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio _dio;

  ProductsRepositoryImpl(this._dio);
  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.auth().put('/products/$id', data: {'enabled': false});
    } on DioError catch (e, s) {
      log('Erro ao deletar produto', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao deletar producto');
    }
  }

  @override
  Future<List<ProductModel>> findAll(String? name) async {
    try {
      final productList = await _dio.auth().get(
        '/products',
        queryParameters: {if (name != null) 'name': name, 'enabled': true},
      );
      return productList.data
          .map<ProductModel>((product) => ProductModel.fromMap(product))
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar  produtos', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao buscar productos');
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    try {
      final productList = await _dio.auth().get(
            '/products/$id',
          );
      return ProductModel.fromMap(productList.data);
    } on DioError catch (e, s) {
      log('Erro ao buscar  produto $id', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao buscar produto $id');
    }
  }

  @override
  Future<void> save(ProductModel productModel) async {
    try {
      final client = _dio.auth();

      if (productModel.id != null) {
        await client.put(
          '/products/${productModel.id}',
          data: productModel.toMap(),
        );
      } else {
        await client.post(
          '/products',
          data: productModel.toMap(),
        );
      }
    } on DioError catch (e, s) {
      log('Erro ao slavar produto', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao salvar produto');
    }
  }

  @override
  Future<String> uploadImageProduct(Uint8List file, String filename) async {
    try {
      final formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(file, filename: filename),
        },
      );
      final response = await _dio.auth().post('/uploads', data: formData);
      return response.data['url'];
    } on DioError catch (e, s) {
      log('Erro ao slavar  imagem', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao slavar  imagem');
    }
  }
}

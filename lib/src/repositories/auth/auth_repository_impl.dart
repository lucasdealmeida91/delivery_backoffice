import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/exceptions/repository_excception.dart';
import '../../core/exceptions/unauthorized_exceptions.dart';
import '../../core/rest_client/custom_dio.dart';
import '../../model/auth_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomDio _dio;
  AuthRepositoryImpl(
    this._dio,
  );
  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final result = await _dio.unauth().post(
        '/auth',
        data: {
          'email': email,
          'password': password,
          'admin': true,
        },
      );
      return AuthModel.fromMap(result.data);
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 403) {
        log('Login ou senha invalidos', error: e, stackTrace: s);
        throw UnauthorizedExceptions();
      }
      log('Erro ao realizar login', error: e, stackTrace: s);
      throw RepositoryExcception(message: 'Erro ao realizar login');
    }
  }
}

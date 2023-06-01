import '../../storage/storage.dart';
import 'package:dio/dio.dart';

import '../../global/contants.dart';
import '../../global/global_context.dart';

class AuthInterceptor extends Interceptor {
  final Storage storage;

  AuthInterceptor(this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = storage.getData(SessionStorageKeys.accesToken.key);
    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
    //super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      GlobalContext.instance.loginExpire();
    } else {
      handler.next(err);
    }
    super.onError(err, handler);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'secure_storage.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('[REQUEST] ${options.method} ${options.path}');
        if (options.data != null) {
          debugPrint('[BODY] ${options.data}');
        }
        final token = await SecureStorageService.getToken();
        if (token != null) {
          debugPrint('\n\n==== TOKEN ====\n$token\n==== TOKEN ====\n\n');
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('[RESPONSE] ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) async {
        debugPrint('[ERROR] ${error.response?.statusCode} ${error.requestOptions.path}');
        if (error.response?.statusCode == 401) {
          await SecureStorageService.clearAll();
        }
        handler.next(error);
      },
    ));

    return dio;
  }
}

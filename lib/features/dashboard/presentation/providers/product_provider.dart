import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepositoryImpl _repository = ProductRepositoryImpl();

  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;
  bool get isLoading => _status == ProductStatus.loading;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      _status = ProductStatus.loaded;
    } on DioException catch (e) {
      _error = e.response?.data['message'] as String? ?? 'Gagal memuat produk';
      _status = ProductStatus.error;
    } catch (e) {
      _error = 'Gagal memuat produk';
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}

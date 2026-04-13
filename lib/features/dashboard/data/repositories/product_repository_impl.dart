import '../../../core/constants/api_constants.dart';
import '../../../core/services/dio_client.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts({int page = 1, int limit = 10, String? category}) async {
    final response = await DioClient.instance.get(
      ApiConstants.products,
      queryParameters: {
        'page': page,
        'limit': limit,
        'category': category,
      },
    );
    final List<dynamic> data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await DioClient.instance.get('${ApiConstants.products}/$id');
    return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}

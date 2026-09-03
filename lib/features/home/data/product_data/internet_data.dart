import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopping_app/core/API/api_key.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class ProductApiService {
  Future<List<Product>> search(String query) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      '${ApiKey.dummyJsonUrl}/search',
    ).replace(queryParameters: {'q': query, 'limit': '10'});

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['products'] as List)
        .cast<Map<String, dynamic>>()
        .map(Product.fromDummyJson)
        .toList();

    return results;
  }

  Future<List<Product>> getAllProducts({int limit = 10, int skip = 0}) async {
    final uri = Uri.parse(
      '${ApiKey.dummyJsonUrl}/',
    ).replace(queryParameters: {'limit': '$limit', 'skip': '$skip'});

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch products (${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['products'] as List)
        .cast<Map<String, dynamic>>()
        .map(Product.fromDummyJson)
        .toList();
  }
}

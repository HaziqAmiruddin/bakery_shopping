import 'dart:async';
import 'package:shopping_app/features/home/data/product_data/internet_data.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class SearchRepository {
  SearchRepository({ProductApiService? apiService})
    : _apiService = apiService ?? ProductApiService();

  final ProductApiService _apiService;

  List<Product> _filterLocal(String query) {
    final q = query.toLowerCase();
    return localProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q),
        )
        .toList();
  }

  /// Returns local matches instantly, remote matches once the API responds.
  Future<List<Product>> search(String query) async {
    final local = _filterLocal(query);

    try {
      final remote = await _apiService.search(query);
      return [...local, ...remote];
    } catch (_) {
      // Network failure — still show local results instead of erroring out.
      return local;
    }
  }
}

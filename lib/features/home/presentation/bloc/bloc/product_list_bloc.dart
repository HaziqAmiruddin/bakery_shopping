// presentation/bloc/product_list/product_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/domain/useccase/get_featured_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_new_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_online_products_usecase.dart';
import 'package:shopping_app/features/home/domain/useccase/get_popular_products_useccase.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/product_list_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;
  final GetNewProductsUseCase getNewProductsUseCase;
  final GetPopularProductsUseCase getPopularProductsUseCase;
  final GetOnlineProductsUseCase getOnlineProductsUseCase;

  ProductListBloc({
    required this.getFeaturedProductsUseCase,
    required this.getNewProductsUseCase,
    required this.getPopularProductsUseCase,
    required this.getOnlineProductsUseCase,
  }) : super(ProductListLoading()) {
    on<FetchProductLists>(_onFetchProductLists);
  }

  Future<void> _onFetchProductLists(
    FetchProductLists event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      final results = await Future.wait([
        getFeaturedProductsUseCase(),
        getNewProductsUseCase(),
        getPopularProductsUseCase(),
      ]);

      // List<Product> onlineProducts = [];
      // try {
      //   onlineProducts = await getOnlineProductsUseCase();
      // } catch (_) {
      //   onlineProducts = [];
      // }

      emit(
        ProductListLoaded([
          ProductListSection(title: 'Featured products', products: results[0]),
          ProductListSection(title: 'New products', products: results[1]),
          ProductListSection(title: 'Popular products', products: results[2]),
          // ProductListSection(
          //   title: titleOfTheListOfProducts[3],
          //   products: onlineProducts,
          // ),
        ]),
      );
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }
}

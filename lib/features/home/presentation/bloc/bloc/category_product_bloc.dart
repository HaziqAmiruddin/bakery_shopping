import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/home/domain/useccase/get_product_by_category_usecase.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/category_product_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/category_product_state.dart';

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  CategoryProductsBloc(this.getProductsByCategoryUseCase)
    : super(CategoryProductsLoading()) {
    on<FetchCategoryProducts>(_onFetchCategoryProducts);
  }

  Future<void> _onFetchCategoryProducts(
    FetchCategoryProducts event,
    Emitter<CategoryProductsState> emit,
  ) async {
    emit(CategoryProductsLoading());
    try {
      final products = await getProductsByCategoryUseCase(event.category);
      emit(CategoryProductsLoaded(products, event.category));
    } catch (e) {
      emit(CategoryProductsError(e.toString()));
    }
  }
}

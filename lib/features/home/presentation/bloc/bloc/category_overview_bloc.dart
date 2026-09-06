import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/home/data/product_data/local_data.dart';
import 'package:shopping_app/features/home/domain/useccase/get_product_usecase.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/category_overview_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/category_overview_state.dart';

class CategoryOverviewBloc
    extends Bloc<CategoryOverviewEvent, CategoryOverviewState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  CategoryOverviewBloc(this.getAllProductsUseCase)
    : super(CategoryOverviewLoading()) {
    on<FetchAllCategories>(_onFetchAllCategories);
  }

  Future<void> _onFetchAllCategories(
    FetchAllCategories event,
    Emitter<CategoryOverviewState> emit,
  ) async {
    emit(CategoryOverviewLoading());
    try {
      final allProducts = await getAllProductsUseCase();

      // Group products under each known category, preserving titlesOfCategories order
      final sections = <CategorySection>[
        for (var i = 0; i < titlesOfCategories.length; i++)
          CategorySection(
            title: titlesOfCategories[i],
            icon: imagesOfCategories[i],
            products: allProducts
                .where((p) => p.category == titlesOfCategories[i])
                .toList(),
          ),
      ]..removeWhere((section) => section.products.isEmpty);

      emit(CategoryOverviewLoaded(sections));
    } catch (e) {
      emit(CategoryOverviewError(e.toString()));
    }
  }
}

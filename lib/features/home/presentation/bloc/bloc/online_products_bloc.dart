import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/features/home/domain/useccase/get_product_usecase.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/online_products_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/online_products_state.dart';

class OnlineProductsBloc
    extends Bloc<OnlineProductsEvent, OnlineProductsState> {
  final GetOnlineProductsUseCase getOnlineProductsUseCase;
  static const _pageSize = 10;

  OnlineProductsBloc(this.getOnlineProductsUseCase)
    : super(OnlineProductsLoading()) {
    on<FetchInitialOnlineProducts>(_onFetchInitial);
    on<FetchMoreOnlineProducts>(_onFetchMore);
  }

  Future<void> _onFetchInitial(
    FetchInitialOnlineProducts event,
    Emitter<OnlineProductsState> emit,
  ) async {
    emit(OnlineProductsLoading());
    try {
      final products = await getOnlineProductsUseCase(
        skip: 0,
        limit: _pageSize,
      );
      emit(
        OnlineProductsLoaded(
          products: products,
          hasMore: products.length == _pageSize,
        ),
      );
    } catch (e) {
      emit(OnlineProductsError(e.toString()));
    }
  }

  Future<void> _onFetchMore(
    FetchMoreOnlineProducts event,
    Emitter<OnlineProductsState> emit,
  ) async {
    final current = state;
    if (current is! OnlineProductsLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = await getOnlineProductsUseCase(
        skip: current.products.length,
        limit: _pageSize,
      );

      emit(
        current.copyWith(
          products: [...current.products, ...nextPage],
          hasMore: nextPage.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      // Keep existing products visible; just stop the loading indicator.
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}

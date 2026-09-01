import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/features/home/data/product_data/internet_data.dart';
import 'package:shopping_app/features/home/presentation/bloc/bloc/online_products_bloc.dart';
import 'package:shopping_app/features/home/presentation/bloc/event/online_products_event.dart';
import 'package:shopping_app/features/home/presentation/bloc/state/online_products_state.dart';
import 'package:shopping_app/features/home/presentation/pages/product_screen.dart';

class OnlineProductsScreen extends StatefulWidget {
  const OnlineProductsScreen({super.key});

  @override
  State<OnlineProductsScreen> createState() => _OnlineProductsScreenState();
}

class _OnlineProductsScreenState extends State<OnlineProductsScreen> {
  final _scrollController = ScrollController();
  late final OnlineProductsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<OnlineProductsBloc>()..add(FetchInitialOnlineProducts());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc.add(FetchMoreOnlineProducts()); // direct reference, no context.read
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc
        .close(); // registerFactory gives a fresh instance each time — close it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnlineProductsBloc>.value(
      value: _bloc,
      child: BlocBuilder<OnlineProductsBloc, OnlineProductsState>(
        builder: (context, state) {
          if (state is OnlineProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OnlineProductsError) {
            return Center(child: Text(state.message));
          }
          if (state is OnlineProductsLoaded) {
            return ProductsScreen(
              products: state.products,
              title: 'Online products',
              scrollController: _scrollController,
              onLoadMore: () => _bloc.add(FetchMoreOnlineProducts()),
              isLoadingMore: state.isLoadingMore,
              onSearch: (query) => getIt<ProductApiService>().search(query),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

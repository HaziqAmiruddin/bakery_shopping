// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:shopping_app/core/gen/assets.gen.dart';
// import 'package:shopping_app/core/theme/app_theme.dart';
// import 'package:shopping_app/core/theme/dimens.dart';
// import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
// import 'package:shopping_app/core/widgets/shaded_container.dart';
// import 'package:shopping_app/features/home/data/repo/search_repo.dart';
// import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

// class AppSearchBar extends StatefulWidget {
//   const AppSearchBar({super.key, this.onProductSelected});

//   final ValueChanged<Product>? onProductSelected;

//   @override
//   State<AppSearchBar> createState() => _AppSearchBarState();
// }

// class _AppSearchBarState extends State<AppSearchBar> {
//   final _repository = SearchRepository();
//   final _searchController = SearchController();
//   Timer? _debounce;

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<List<Product>> _debouncedSearch(String query) {
//     final completer = Completer<List<Product>>();
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 350), () async {
//       completer.complete(await _repository.search(query));
//     });
//     return completer.future;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.theme.appColors;

//     return SearchAnchor(
//       searchController: _searchController,
//       builder: (context, controller) {
//         return ShadedContainer(
//           height: 50,
//           child: Padding(
//             padding: const EdgeInsets.only(top: Dimens.smallPadding),
//             child: TextField(
//               controller: controller,
//               onTap: () => controller.openView(),
//               onChanged: (_) => controller.openView(),
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 hintText: 'Search for cakes, pastries, cheesecakes',
//                 hintStyle: TextStyle(color: colors.gray2, fontSize: 13),
//                 prefixIcon: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: Dimens.mediumPadding,
//                   ),
//                   child: AppSvgViewer(
//                     Assets.icons.searchNormal1,
//                     width: 8,
//                     height: 8,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//       suggestionsBuilder: (context, controller) async {
//         final query = controller.text;
//         if (query.trim().isEmpty) return const [];

//         final results = await _debouncedSearch(query);

//         if (results.isEmpty) {
//           return [const ListTile(title: Text('No products found'))];
//         }

//         return results.map((product) {
//           return ListTile(
//             leading: SizedBox(
//               width: 40,
//               height: 40,
//               child: product.source == ProductSource.remote
//                   ? Image.network(product.image, fit: BoxFit.cover)
//                   : Image.asset(product.image, fit: BoxFit.cover),
//             ),
//             title: Text(product.name),
//             subtitle: Text(product.category),
//             trailing: product.price != null
//                 ? Text('\$${product.price!.toStringAsFixed(2)}')
//                 : null,
//             onTap: () {
//               controller.closeView(product.name);
//               widget.onProductSelected?.call(product);
//             },
//           );
//         }).toList();
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/shaded_container.dart';
import 'package:shopping_app/features/home/data/repo/search_repo.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';
import 'package:shopping_app/features/home/presentation/pages/product_details_screen.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({super.key, this.onProductSelected});

  final ValueChanged<Product>? onProductSelected;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _repository = SearchRepository();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();

  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  List<Product> _results = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }

  void _onChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      _removeOverlay();
      return;
    }

    setState(() => _loading = true);
    _showOverlay();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final results = await _repository.search(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
      _showOverlay(); // rebuild overlay with fresh results
    });
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectProduct(Product product) {
    _textController.clear();
    setState(() => _results = []);
    _removeOverlay();
    _focusNode.unfocus();

    widget.onProductSelected?.call(product);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
    );
  }

  OverlayEntry _buildOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    //final colors = context.theme.appColors;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 6),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : _results.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final product = _results[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product.source == ProductSource.remote
                                  ? Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      product.image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(product.category),
                          trailing: product.price != null
                              ? Text('\$${product.price!.toStringAsFixed(2)}')
                              : null,
                          onTap: () => _selectProduct(product),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return CompositedTransformTarget(
      link: _layerLink,
      child: ShadedContainer(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(top: Dimens.smallPadding),
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            onChanged: _onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Search for cakes, pastries, cheesecakes',
              hintStyle: TextStyle(color: colors.gray2, fontSize: 13),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.mediumPadding,
                ),
                child: AppSvgViewer(
                  Assets.icons.searchNormal1,
                  width: 8,
                  height: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

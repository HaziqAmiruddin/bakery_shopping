// core/widgets/inline_search_field.dart
import 'package:flutter/material.dart';
import 'package:shopping_app/core/gen/assets.gen.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_svg_viewer.dart';
import 'package:shopping_app/core/widgets/shaded_container.dart';

class InlineSearchField extends StatelessWidget {
  const InlineSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search products',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return ShadedContainer(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(top: Dimens.smallPadding),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText,
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
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

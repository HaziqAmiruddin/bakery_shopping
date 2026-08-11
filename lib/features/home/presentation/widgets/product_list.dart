import 'package:flutter/material.dart';
import 'package:shopping_app/core/widgets/app_title_widget.dart';
import 'package:shopping_app/features/home/data/sample_data.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titleOfTheListOfProducts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (final context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTitleWidget(
              title: titleOfTheListOfProducts[index],
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}

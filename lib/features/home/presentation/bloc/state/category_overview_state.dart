import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/home/domain/entities/product_entities.dart';

class CategorySection extends Equatable {
  final String title;
  final String icon;
  final List<Product> products;

  const CategorySection({
    required this.title,
    required this.icon,
    required this.products,
  });

  @override
  List<Object?> get props => [title, icon, products];
}

abstract class CategoryOverviewState extends Equatable {
  const CategoryOverviewState();
  @override
  List<Object?> get props => [];
}

class CategoryOverviewLoading extends CategoryOverviewState {}

class CategoryOverviewLoaded extends CategoryOverviewState {
  final List<CategorySection> sections;
  const CategoryOverviewLoaded(this.sections);

  @override
  List<Object?> get props => [sections];
}

class CategoryOverviewError extends CategoryOverviewState {
  final String message;
  const CategoryOverviewError(this.message);

  @override
  List<Object?> get props => [message];
}

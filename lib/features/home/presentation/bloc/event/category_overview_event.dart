import 'package:equatable/equatable.dart';

abstract class CategoryOverviewEvent extends Equatable {
  const CategoryOverviewEvent();
  @override
  List<Object?> get props => [];
}

class FetchAllCategories extends CategoryOverviewEvent {}

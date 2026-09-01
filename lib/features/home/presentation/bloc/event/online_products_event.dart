import 'package:equatable/equatable.dart';

abstract class OnlineProductsEvent extends Equatable {
  const OnlineProductsEvent();
  @override
  List<Object?> get props => [];
}

class FetchInitialOnlineProducts extends OnlineProductsEvent {}

class FetchMoreOnlineProducts extends OnlineProductsEvent {}

import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

// class FetchProductsEvent extends ProductEvent{}

class FetchNextProductsEvent extends ProductEvent{
  final String categoryId;
  FetchNextProductsEvent(this.categoryId);
  @override
  List<Object> get props =>[categoryId];
}

class FetchByCategoryEvent extends ProductEvent{
  final String categoryId;
  FetchByCategoryEvent(this.categoryId);
  @override
  List<Object> get props =>[categoryId];
}


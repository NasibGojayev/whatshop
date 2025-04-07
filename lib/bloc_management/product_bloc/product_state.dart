import 'package:equatable/equatable.dart';

import '../d_product_bloc/d_product_bloc.dart';

abstract class ProductState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState{}

class ProductLoadedState extends ProductState{
  final List<Product> products;

  ProductLoadedState({required this.products});
  @override
  List<Object?> get props =>[products];

}

class ProductErrorState extends ProductState{
  final String error;
  ProductErrorState(this.error);

  @override
  List<Object> get props =>[error];

}

class ProductPaginatingState extends ProductState{
  final List<Map<String, dynamic>> products;
  ProductPaginatingState(this.products);
  @override
  List<Object?> get props => [products];
}





class EndOfPageState extends ProductState{}

class EndOfProductsState extends ProductState{}


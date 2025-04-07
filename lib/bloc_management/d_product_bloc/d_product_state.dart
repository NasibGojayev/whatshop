import 'dart:ffi';

import 'package:equatable/equatable.dart';

import 'd_product_bloc.dart';

abstract class ProductIdState extends Equatable{
  @override
  List<Object?> get props => [];

}

class ProductIdLoadingState extends ProductIdState{}

class ProductIdErrorState extends ProductIdState{
  final String error;
  ProductIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

class ProductIdFetchedState extends ProductIdState{
  final Product product;
  final ColorOption colorOption;
  final SizeOption sizeOption;

  ProductIdFetchedState({
    required this.product,
    required this.colorOption,
    required this.sizeOption});
  @override
  List<Object?> get props => [product,colorOption,sizeOption];
}





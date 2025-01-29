import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProductState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState{}

class ProductLoadedState extends ProductState{
  final List<DocumentSnapshot> products;

  ProductLoadedState(this.products);
  @override
  List<Object?> get props =>[products];

}

class ProductErrorState extends ProductState{
  final String error;
  ProductErrorState(this.error);

  @override
  List<Object> get props =>[error];

}

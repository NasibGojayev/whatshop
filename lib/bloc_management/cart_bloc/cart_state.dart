import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable{
  @override
  List<Object> get props =>[];
}



class CartLoadingState extends CartState{}

class CartLoadedState extends CartState{
  final List<Map<String,dynamic>> cartProducts;
  final List<Map<String,dynamic>> cart;
  CartLoadedState(this.cart,this.cartProducts);
  @override
  List<Object> get props => [cart,cartProducts];
}
class CartErrorState extends CartState{
  final String error;
  CartErrorState(this.error);

  @override
  List<Object> get props =>[error];
}
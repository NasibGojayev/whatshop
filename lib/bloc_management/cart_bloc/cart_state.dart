import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable{
  @override
  List<Object> get props =>[];
}

class NotLoggedInState extends CartState{
  final List<String> cart;
  NotLoggedInState(this.cart);
  @override
  List<Object> get props => [cart];
}

class CartLoadingState extends CartState{}

class CartLoadedState extends CartState{
  final List<String> cart;
  CartLoadedState(this.cart);
  @override
  List<Object> get props => [cart];
}
class CartErrorState extends CartState{
  final String error;
  CartErrorState(this.error);

  @override
  List<Object> get props =>[error];
}
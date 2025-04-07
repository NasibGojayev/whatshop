import 'package:equatable/equatable.dart';

import '../d_product_bloc/d_product_bloc.dart';

abstract class CartState extends Equatable{
  @override
  List<Object> get props =>[];
}



class CartLoadingState extends CartState{}

class CartLoadedState extends CartState{
  final List<CartItem> cart;
  double total=0;
  CartLoadedState(this.cart, this.total);
  @override
  List<Object> get props => [cart];
}
class CartErrorState extends CartState{
  final String error;
  CartErrorState(this.error);

  @override
  List<Object> get props =>[error];
}
class CartUpdatingQuantityState extends CartState{
  final List<CartItem> cart;
  double total=0;
  final String updatingProductId;
  CartUpdatingQuantityState(this.cart, this.updatingProductId,this.total);
  @override
  List<Object> get props => [cart];
}

class CartEmptyState extends CartState{}


class CartItem{
  final String productId;
  final String name;
  final String image;

  final ColorOption colorOption;
  final SizeOption sizeOption;
  int quantity;
  bool isSelected;
  CartItem(
      {
        required this.sizeOption,
        required this.colorOption,
        required this.name,
        required this.image,
        required this.productId,
        required this.quantity,
        required this.isSelected
      });

  /*Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'isSelected': isSelected,
      'product_name': name,
      'product_image': image,
      'product_price': price,
      'color': color,
      'size': size,
    };
  }*/
  Map<String, dynamic> forDb() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'isSelected': isSelected,
      'color': colorOption.color,
      'size': sizeOption.size,
    };
  }
}

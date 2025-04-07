import 'package:equatable/equatable.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_bloc.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object> get props =>[];
}


class UpdateCartQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  UpdateCartQuantityEvent({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object> get props => [productId, quantity];
}


class FetchCartEvent extends CartEvent{}

class AddCartEvent extends CartEvent{
  final ColorOption colorOption;
  final SizeOption sizeOption;
  final Product product;
  AddCartEvent({
    required this.colorOption,
    required this.sizeOption,
    required this.product,
});
  @override
  List<Object> get props => [product];
}
class ToggleSelectedEvent extends CartEvent {
  final String productId;
  ToggleSelectedEvent(this.productId);
}

class DeleteCartEvent extends CartEvent {
  final String productId;

  DeleteCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
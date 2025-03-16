import 'package:equatable/equatable.dart';

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
  final Map<String,dynamic> product;
  AddCartEvent(this.product);
  @override
  List<Object> get props => [product];
}

class DeleteCartEvent extends CartEvent {
  final String productId;

  DeleteCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class FetchCartEvent extends CartEvent{}

class ToggleCartEvent extends CartEvent{
  final String productId;
  ToggleCartEvent(this.productId);
  @override
  List<Object> get props => [productId];
}

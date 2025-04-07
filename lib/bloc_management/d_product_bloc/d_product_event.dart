import 'package:equatable/equatable.dart';

abstract class ProductIdEvent extends Equatable{
  @override
  List<Object?> get props => [];

}

class FetchProductIdEvent extends ProductIdEvent{
  final String productId;
  FetchProductIdEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class SelectColorEvent extends ProductIdEvent{
  final String color;
  SelectColorEvent({required this.color});
  @override
  List<Object?> get props => [color];

}

class SelectSizeEvent extends ProductIdEvent {
  final String size;
  final double price;

  SelectSizeEvent({
    required this.size,
    required this.price});

  @override
  List<Object?> get props => [size];
}

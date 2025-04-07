import '../d_product_bloc/d_product_bloc.dart';

abstract class FavoriteEvent{}

class CaptureProductsEvent extends FavoriteEvent{}

class ToggleFavoriteEvent extends FavoriteEvent{
  Product product;
  ToggleFavoriteEvent({required this.product});
}

class RemoveFavoriteEvent extends FavoriteEvent{
  String productId;
  RemoveFavoriteEvent(this.productId);
}

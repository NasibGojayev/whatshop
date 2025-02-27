import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable{
  @override
  List<Object> get props =>[];
}

class FetchFavoritesEvent extends FavoriteEvent{}

class ToggleFavoriteEvent extends FavoriteEvent{
  final String productId;
  ToggleFavoriteEvent(this.productId);
  @override
  List<Object> get props => [productId];
}

import 'package:equatable/equatable.dart';
import 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchFavoriteEvent extends FavoriteEvent{}


class ToggleFavoriteEvent extends FavoriteEvent{
  final FavoriteObject favoriteObject;
  ToggleFavoriteEvent({required this.favoriteObject});
  @override
  List<Object?> get props => [favoriteObject];
}

class RemoveFavoriteEvent extends FavoriteEvent{
  final String productId;
  RemoveFavoriteEvent(this.productId);
  @override
  List<Object?> get props => [productId];

}

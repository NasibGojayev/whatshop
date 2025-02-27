import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable{
  @override
  List<Object> get props =>[];
}

/*class FavNotLoggedInState extends FavoriteState{
  final List<String> favorites;
  FavNotLoggedInState(this.favorites);
  @override
  List<Object> get props => [favorites];
}*/

class FavoriteLoadingState extends FavoriteState{}

class FavoriteLoadedState extends FavoriteState{
  final List<String> favorites;
  final List<Map<String,dynamic>> favoriteProducts;
  FavoriteLoadedState(this.favorites,this.favoriteProducts);

  @override
  List<Object> get props => [favorites,favoriteProducts];
}
class FavoriteErrorState extends FavoriteState{
  final String error;
  FavoriteErrorState(this.error);

  @override
  List<Object> get props =>[error];
}
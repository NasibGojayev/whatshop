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
  FavoriteLoadedState(this.favorites);
  @override
  List<Object> get props => [favorites];
}
class FavoriteErrorState extends FavoriteState{
  final String error;
  FavoriteErrorState(this.error);

  @override
  List<Object> get props =>[error];
}
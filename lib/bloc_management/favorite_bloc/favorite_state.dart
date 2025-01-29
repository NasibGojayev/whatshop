import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable{
  @override
  List<Object> get props =>[];
}


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
import 'package:equatable/equatable.dart';
import 'favorite_bloc.dart';

abstract class FavoriteStates extends Equatable{
  @override
  List<Object?> get props => [];
}


class FavoriteLoadingState extends FavoriteStates {}


class FavoriteLoadedState extends FavoriteStates {
  final List<FavoriteObject> favorites;
  FavoriteLoadedState(this.favorites);
  @override
  List<Object?> get props => [favorites];
}

class FavoriteErrorState extends FavoriteStates {
  final String message;
  FavoriteErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class FavoriteEmptyState extends FavoriteStates {}


import 'package:equatable/equatable.dart';
import 'package:whatshop/bloc_management/rating_cubit/rating_cubit.dart';

abstract class RatingState extends Equatable{
  @override
  List<Object?> get props => [];
}

class RatingLoadingState extends RatingState{}

class RatingFetchedState extends RatingState{
  final List<RatingObject> ratings;
  final double ratingAvg;
  RatingFetchedState({required this.ratings,required this.ratingAvg});
  @override
  List<Object?> get props => [ratings];
}

class RatingErrorState extends RatingState{
  final String error;
  RatingErrorState(this.error);
  @override
  List<Object?> get props => [error];

}
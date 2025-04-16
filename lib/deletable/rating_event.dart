import 'package:equatable/equatable.dart';

abstract class RatingEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchRatingEvent extends RatingEvent{
  final String productId;
  FetchRatingEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class DeleteRatingEvent extends RatingEvent{
  final String productId;
  final String userId;
  DeleteRatingEvent(this.productId, this.userId);
  @override
  List<Object?> get props => [productId];
}

class AddRatingEvent extends RatingEvent{
  final int rating;
  final String productId;
  final String comment;
  AddRatingEvent({required this.rating,required this.productId,required this.comment});
  @override
  List<Object?> get props => [rating];

}



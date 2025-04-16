import 'package:equatable/equatable.dart';

import 'comment_bloc.dart';

abstract class CommentEvent extends Equatable{
  @override
  List get props =>[];

}

class FetchCommentsEvent extends CommentEvent{
  final String productId;

  FetchCommentsEvent(this.productId);
  @override
  List get props =>[productId];
}

class AddCommentEvent extends CommentEvent{
  final String productId;
  final String comment;
  final DateTime time;
  AddCommentEvent({required this.comment,required this.productId,required this.time});
  @override
  List get props =>[comment,productId,time];
}

class DeleteCommentEvent extends CommentEvent{
  final String commentId;
  DeleteCommentEvent({required this.commentId});
  @override
  List get props =>[commentId];
}

class ToggleLikeEvent extends CommentEvent{
  final Comment comment;
  ToggleLikeEvent({required this.comment});
  @override
  List get props =>[comment];
}




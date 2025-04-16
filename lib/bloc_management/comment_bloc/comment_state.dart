import 'package:equatable/equatable.dart';

import 'comment_bloc.dart';

abstract class CommentState extends Equatable{
  @override
  List get props =>[];
}

class CommentLoadingState extends CommentState{}

class CommentLoadedState extends CommentState{
  final List<Comment> comments;
  CommentLoadedState({required this.comments});
  @override
  List get props =>[comments];
}
class CommentEmptyState extends CommentState{}

class CommentErrorState extends CommentState{
  final String error;
  CommentErrorState(this.error);
  @override
  List get props =>[error];
}

class LikeToggledState extends CommentState{
  final String commentId;
  LikeToggledState({required this.commentId});
  @override
  List get props =>[commentId];
}




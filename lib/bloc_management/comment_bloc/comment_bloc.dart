import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'comment_event.dart';
import 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent,CommentState>{
  final SupabaseClient supabase;
  CommentBloc(this.supabase) : super(CommentLoadingState()){
    on<FetchCommentsEvent>(_onFetchComments);
    on<AddCommentEvent>(_onAddComment);
    on<DeleteCommentEvent>(_onDeleteComment);
    on<ToggleLikeEvent>(_onToggleLike);
    init();
  }

  final List<Comment> _comments = [];
  String? userName;

  void init(){
    _comments.clear();
    if(supabase.auth.currentUser != null){
      userName = supabase.auth.currentUser!.userMetadata?['username'];
    }
    else{
      debugPrint('user not found in the comments bloc ');
    }
  }

  Future<void> _onFetchComments(FetchCommentsEvent event, Emitter<CommentState> emit)async{
    emit(CommentLoadingState());
    try{
      _comments.clear();
      var json = await supabase.from('comments').select('*').eq("product_id", event.productId).order('created_at', ascending: false);

      for(var i in json){
        _comments.add(Comment.fromJson(i));
      }
      if(_comments.isEmpty){
        emit(CommentEmptyState());
        return;
      }

      emit(CommentLoadedState(comments: _comments));
    }
    catch(e){
      emit(CommentErrorState(e.toString()));
    }

  }

  Future<void> _onAddComment(AddCommentEvent event, Emitter<CommentState> emit)async{
    emit(CommentLoadingState());
    try{
      print('comment added to supabase');

      await supabase.from('comments').insert({
        'user_id': userName,
        'product_id': event.productId,
        'comment': event.comment,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('comment added');

      _comments.insert(0,(Comment(
          commentId: 'yeni komment',
          userId: userName!,
          productId: event.productId,
          comment: event.comment,
          time: DateTime.now()
      )));
      emit(CommentLoadedState(comments: _comments));
    }catch(e){
      emit(CommentErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<CommentState> emit)async{
    emit(CommentLoadingState());
    try{

    }catch(e){
      emit(CommentErrorState(e.toString()));
    }

  }

  Future<void> _onToggleLike(ToggleLikeEvent event, Emitter<CommentState> emit)async{
    emit(CommentLoadingState());
    try{

    }
    catch(e){
      emit(CommentErrorState(e.toString()));
    }
  }


}

class Comment{
  final bool isLiked;
  final String commentId;
  final String productId;
  final String comment;
  final DateTime time;
  final String userId;
  Comment({
    required this.userId,
    this.isLiked = false,
    required this.commentId,
    required this.productId,
    required this.comment,
    required this.time});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user_id'],
      time: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      //isLiked: json['is_liked'],
      commentId: json['id'].toString(),
      productId: json['product_id'],
      comment: json['comment'],
    );
  }

}


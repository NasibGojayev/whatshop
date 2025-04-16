/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/rating_bloc/rating_event.dart';
import 'package:whatshop/bloc_management/rating_bloc/rating_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final SupabaseClient _supabase; // Injected dependency
  RatingBloc(this._supabase) : super(RatingLoadingState()) {
    on<FetchRatingEvent>(_onFetchRating);
    on<DeleteRatingEvent>(_onDeleteRating);
    on<AddRatingEvent>(_onAddRating);
    init();
  }

  List<RatingObject> ratings = [];
  int totalStars = 0;
  late User? user;
  late String userId;

  void init() {
    user = _supabase.auth.currentUser;
    if (user != null) {
      userId = user!.id;
    } else {
      print("User is null");
    }
  }


  Future<void> _onFetchRating(FetchRatingEvent event, Emitter<RatingState> emit) async {
    emit(RatingLoadingState());
    try {
      final json = await _supabase.from('ratings').select("*").eq('product_id', event.productId);

      ratings = json.map<RatingObject>((item){
        return RatingObject(
              userId: item['user_id'],
              comment: item['comment'] as String,
              productId: event.productId,
              rating: item['rating'] as int,
        );
      }).toList();

      for(var i in ratings){
        totalStars += i.rating;
      }

      emit(RatingFetchedState(ratings: ratings,ratingAvg: totalStars/ratings.length));
    } catch (e) {
      emit(RatingErrorState(e.toString()));}
  }



  Future<void> _onDeleteRating(
      DeleteRatingEvent event, Emitter<RatingState> emit
      ) async{
    try{
      ratings.removeWhere((e)=> e.userId ==userId);
      _supabase.from('ratings').delete().eq('user_id', userId);

    }catch(e){
      emit(RatingErrorState(e.toString()));}
  }


  Future<void> _onAddRating(
      AddRatingEvent event, Emitter<RatingState> emit
      ) async{
    try{
      bool hasComment = ratings.any((e){
        return e.userId==userId;
      });
      print('starting then');


      if(!hasComment){
        await _supabase.from('ratings').insert([
          {
            'created_at': DateTime.now()
                .toIso8601String()
                .substring(0, 16),
            'product_id': event.productId,
            'user_id': userId,
            'comment' : event.comment,
            'rating': event.rating,
          }
        ]);
        await _supabase.from('products').update({
          'rating_count' : ratings.length+1,
          'rating_avg': (totalStars+event.rating)/(ratings.length+1),
        }).eq('product_id', event.productId);
      }

      print('hello world');
    }
    catch(e){
      emit(RatingErrorState(e.toString()));}
  }
  }*/

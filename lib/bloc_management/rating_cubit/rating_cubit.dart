import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop/bloc_management/rating_cubit/rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final SupabaseClient _supabase;
  RatingCubit(this._supabase) : super(RatingLoadingState()) {
    _init();
  }

  List<RatingObject> ratings = [];
  int totalStars = 0;
  late String userId;

  void _init() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      userId = user.id;
    } else {
    }
  }

  Future<void> fetchRatings(String productId) async {
    emit(RatingLoadingState());
    try {
      final json = await _supabase
          .from('ratings')
          .select("*")
          .eq('product_id', productId);

      ratings = json.map<RatingObject>((item) {
        return RatingObject(
          userId: item['user_id'],
          productId: productId,
          rating: item['rating'] as int,
        );
      }).toList();

      totalStars = ratings.fold(0, (sum, rating) => sum + rating.rating);

      emit(RatingFetchedState(
        ratings: ratings,
        ratingAvg: ratings.isNotEmpty ? totalStars / ratings.length : 0,
      ));
    } catch (e) {
      emit(RatingErrorState(e.toString()));
    }
  }

  Future<void> deleteRating() async {
    try {
      ratings.removeWhere((e) => e.userId == userId);
      await _supabase.from('ratings').delete().eq('user_id', userId);
      // You might want to emit a new state here if needed
    } catch (e) {
      emit(RatingErrorState(e.toString()));
    }
  }

  Future<void> addRating({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final hasRating = ratings.any((e) => e.userId == userId);

      if (!hasRating) {
        await _supabase.from('ratings').insert([
          {
            'created_at': DateTime.now().toIso8601String().substring(0, 16),
            'product_id': productId,
            'user_id': userId,
            'rating': rating,
          }
        ]);

        await _supabase.from('products').update({
          'rating_count': ratings.length + 1,
          'rating_avg': (totalStars + rating) / (ratings.length + 1),
        }).eq('product_id', productId);

        // Refresh ratings after adding new one
        await fetchRatings(productId);
      }
    } catch (e) {
      emit(RatingErrorState(e.toString()));
    }
  }
}
class RatingObject{
  final String productId;
  final String userId;
  final int rating;


  RatingObject({required this.userId, required this.productId,required this.rating});
}
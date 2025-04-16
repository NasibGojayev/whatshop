import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'favorite_events.dart';
import 'favorite_states.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteStates>{
  final SupabaseClient _supabase;
  FavoriteBloc(this._supabase) : super(FavoriteLoadedState([])){
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<FetchFavoriteEvent>(_onFetchFavorite);
    init();

  }
  late User? user;
  late String userId;
  Box<dynamic> box = Hive.box('favorites');

  void init() {
    user = _supabase.auth.currentUser;
    if (user != null) {
      userId = user!.id;
    } else {
    }
  }

  List<FavoriteObject> favorites = [];

  void _onFetchFavorite(
      FetchFavoriteEvent event,
      Emitter<FavoriteStates> emit
      ) {
    try {
      if (box.containsKey(userId)) {
        favorites.clear();
        favorites = (box.get(userId) as List<dynamic>)
            .map((e) => FavoriteObject.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        emit(FavoriteLoadedState(favorites));
      } else {
        emit(FavoriteEmptyState());
      }
    } catch (e) {
      emit(FavoriteErrorState("Error fetching favorites: $e"));
    }
  }





  void _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteStates> emit
      )  async{
    emit(FavoriteLoadingState());
     int index = favorites.indexWhere((e)=>e.productId == event.favoriteObject.productId);

    if(0<=index){
      favorites.removeAt(index);
    }
    else{
      favorites.add(event.favoriteObject);
    }

    await box.put(userId, favorites.map((e) => e.toMap()).toList());
    emit(FavoriteLoadedState(List.from(favorites)));


  }

  void _onRemoveFavorite(
      RemoveFavoriteEvent event,
      Emitter<FavoriteStates> emit
      ) async{
    emit(FavoriteLoadingState());
    favorites.removeWhere((favorite) => favorite.productId == event.productId);

    await box.put(userId, favorites.map((e) => e.toMap()).toList());
    emit(FavoriteLoadedState(favorites));
  }

}


class FavoriteObject{
  final String name;
  final double price;
  final String image;
  final double avgRating;
  final String productId;


  FavoriteObject({
    required this.avgRating,
    required this.name,
    required this.price,
    required this.image,
    required this.productId,
});

  Map<String, dynamic> toMap(){
    return {
      'avgRating': avgRating,
      'name': name,
      'price': price,
      'image': image,
      'productId': productId,};
  }
  factory FavoriteObject.fromMap(Map<String, dynamic> map){
    return FavoriteObject(
      avgRating: map['avgRating'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      productId: map['productId']);
  }
}
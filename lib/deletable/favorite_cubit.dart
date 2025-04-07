/*
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<List<Map<String,dynamic>>>{
  FavoriteCubit() : super([]);

  void toggleFavorite(Map<String,dynamic> product){
    final updatedFavorites = List<Map<String,dynamic>>.from(state);
    if(updatedFavorites.contains(product)){
      updatedFavorites.remove(product);
    }
    else{
      updatedFavorites.add(product);
    }
    emit(updatedFavorites);
  }

  void removeFavorite(String productId){
    final updatedFavorites = List<Map<String,dynamic>>.from(state);

    updatedFavorites.removeWhere((product) => product['product_id'] == productId);
    emit(updatedFavorites);
  }
}*/

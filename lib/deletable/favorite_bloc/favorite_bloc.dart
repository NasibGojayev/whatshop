/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import 'package:whatshop/Auth/auth_service.dart';


class FavoriteBloc extends Bloc<FavoriteEvent,FavoriteState>{
  FavoriteBloc() : super(FavoriteLoadingState()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    _getUserData();
  }


  //---------------------------------------------

  List<String> favorites=[];
  List<Map<String,dynamic>> favoritesProducts=[];

  late Customer? user;
   String? userId;




  Future<void> _getUserData() async{
     user = await AuthService().getCurrentUser();
    if(user != null){
      userId = user!.id;
    }
    else {
      print('user is null');

    }
  }

  // --------------------------------------------


  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event,
      Emitter<FavoriteState> emit
      ) async{
    emit(FavoriteLoadingState());
    try{
      if(user == null){
        emit(FavoriteErrorState("user is null"));
        return;
      }

      final DocumentSnapshot? userDoc = await userRef?.get();
      if(userDoc != null && userDoc.exists){
        favoritesProducts.clear();
        favorites.clear();
        favorites = List<String>.from(userDoc['favorites']);

        for(var productId in favorites){
          final productDoc = await FirebaseFirestore.instance.collection('products').where('id',isEqualTo: productId).get().then((value) => value.docs.first.data());
          favoritesProducts.add(productDoc);
        }

        emit(FavoriteLoadedState(favorites,favoritesProducts));
        return;
      }

    } catch(e){
      emit(FavoriteErrorState("error fetching the favorites : $e"));
    }
  }



  //-------------------------------------------------

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteState> emit) async{

    List<String> updatedList = List.from(favorites); // Create the copy *outside* the try-catch
    List<Map<String,dynamic>> updatedFavoritesProducts = List.from(favoritesProducts);

    try{

      if(user != null){
        if(updatedList.contains(event.productId)){ // Use updatedList here too
          await userRef!.update({
            'favorites': FieldValue.arrayRemove([event.productId]),
          });
          updatedList.remove(event.productId);
          updatedFavoritesProducts.removeWhere((product) => product['id'] == event.productId);

        }
        else {
          await userRef!.update({
            'favorites': FieldValue.arrayUnion([event.productId]),
          });
          updatedList.add(event.productId);
          final productDoc = await FirebaseFirestore.instance.collection('products').where('id',isEqualTo: event.productId).get().then((value) => value.docs.first.data());
          updatedFavoritesProducts.add(productDoc);
        }
        emit(FavoriteLoadedState(updatedList,favoritesProducts));
      }
      else{
        emit(FavoriteErrorState("user is null"));
      }


      favorites = List.from(updatedList); // Update original list as well, if needed
      return;

    }catch(e){
      emit(FavoriteErrorState("could not toggle favorite : $e"));
    }
  }



}*/

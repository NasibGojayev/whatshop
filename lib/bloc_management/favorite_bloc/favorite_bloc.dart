import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent,FavoriteState>{
  FavoriteBloc() : super(FavoriteLoadingState()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    _getUserData();
  }


  //---------------------------------------------

  List<String> favorites=[];

  late User? user;
   String? userId;
   DocumentReference? userRef;




  Future<void> _getUserData() async{
     user = await getCurrentUser();
    if(user != null){
      userId = user!.uid;
      userRef =  FirebaseFirestore.instance.collection('Users').doc(userId);
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

      final userDoc = await userRef!.get();
      if(userDoc.exists){
        favorites = List<String>.from(userDoc['favorites']);
        emit(FavoriteLoadedState(favorites));
        return;
      }

    } catch(e){
      emit(FavoriteErrorState("error fetching the favorites : $e"));
    }
  }
  //----------------------------------------------
  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoriteState> emit) async{

    List<String> updatedList = List.from(favorites); // Create the copy *outside* the try-catch
    try{

      if(user != null){
        if(updatedList.contains(event.productId)){ // Use updatedList here too
          await userRef!.update({
            'favorites': FieldValue.arrayRemove([event.productId]),
          });
          updatedList.remove(event.productId);

        }
        else {
          await userRef!.update({
            'favorites': FieldValue.arrayUnion([event.productId]),
          });
          updatedList.add(event.productId);
        }
        emit(FavoriteLoadedState(updatedList));
      }
      else{

        if(updatedList.contains(event.productId)){
          updatedList.remove(event.productId);
        }
        else{
          updatedList.add(event.productId);
        }

      }

      favorites = List.from(updatedList); // Update original list as well, if needed
      return;

    }catch(e){
      emit(FavoriteErrorState("could not toggle favorite : $e"));
    }
  }



}
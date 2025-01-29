import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent,FavoriteState>{
  FavoriteBloc() : super(FavoriteLoadingState()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }


  //---------------------------------------------
  Future<String?> _userId() async{
    try{
      Customer? user = await AuthRepository.getCurrentUser();
      String? userId = user?.id;
      return userId;
    }catch(e){
      print("ID elde ederken xeta bas verdi $e");
    }
  }
  // ---------------------------------------


  List<String> favorites=[];
  late DocumentReference userRef;
  Future<void> _onFetchFavorites(
      FetchFavoritesEvent event,
      Emitter<FavoriteState> emit
      )async{
    emit(FavoriteLoadingState());
    try{
      String? currentUserId = await _userId();
      if(currentUserId==null){
        emit(FavoriteErrorState('user not found'));
        return;
      }
      userRef = FirebaseFirestore.instance.collection('Users').doc(currentUserId);
      DocumentSnapshot userDoc = await userRef.get();
      if(userDoc.exists){
        favorites = List<String>.from(userDoc['favorites']);
        emit(FavoriteLoadedState(favorites));
        return;
      }
      else{
        emit(FavoriteErrorState("error fetching the favorites"));
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
      String? currentUserId = await _userId();
      if(currentUserId == null){
        emit(FavoriteErrorState("error finding user id"));
        return;
      }

      if(updatedList.contains(event.productId)){ // Use updatedList here too
        await userRef.update({
          'favorites': FieldValue.arrayRemove([event.productId]),
        });
        updatedList.remove(event.productId);

      }
      else {
        await userRef.update({
          'favorites': FieldValue.arrayUnion([event.productId]),
        });
        updatedList.add(event.productId);

      }
      favorites = List.from(updatedList); // Update original list as well, if needed
      emit(FavoriteLoadedState(updatedList)); // Emit the updated list in *both* cases
      return;

    }catch(e){
      emit(FavoriteErrorState("could not toggle favorite : $e"));
    }
  }



}
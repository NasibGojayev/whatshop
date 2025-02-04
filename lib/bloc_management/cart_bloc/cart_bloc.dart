import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent,CartState>{
  CartBloc() : super(CartLoadingState()) {
    on<FetchCartEvent>(_onFetchCart);
    on<ToggleCartEvent>(_onToggleCart);
    _getUserData();
  }


  //---------------------------------------------

  List<String> cart=[];

  late User? user;
  String? userId;
  DocumentReference? userRef;

  var hiveCartBox = Hive.box<List<String>>('cart');



  Future<void> _getUserData() async{
    user = await getCurrentUser();
    if(user != null){
      userId = user!.uid;
      userRef =  FirebaseFirestore.instance.collection('Users').doc(userId);
    }
    else {
      print('user is null');
      cart = hiveCartBox.get('cart') ?? [];

      print(' ${hiveCartBox.get("cart")}');

    }
  }

  // --------------------------------------------


  Future<void> _onFetchCart(
      FetchCartEvent event,
      Emitter<CartState> emit
      ) async{
    emit(CartLoadingState());
    try{
      if(user == null){
        emit(NotLoggedInState(cart));
        return;
      }

      final userDoc = await userRef!.get();
      if(userDoc.exists){
        cart = List<String>.from(userDoc['cart']);
        emit(CartLoadedState(cart));
        return;
      }

    } catch(e){
      emit(CartErrorState("error fetching the cart : $e"));
    }
  }
  //----------------------------------------------
  Future<void> _onToggleCart(
      ToggleCartEvent event,
      Emitter<CartState> emit) async{

    List<String> updatedCart = List.from(cart); // Create the copy *outside* the try-catch
    try{

      if(user != null){
        if(updatedCart.contains(event.productId)){ // Use updatedCart here too
          await userRef!.update({
            'cart': FieldValue.arrayRemove([event.productId]),
          });
          updatedCart.remove(event.productId);

        }
        else {
          await userRef!.update({
            'cart': FieldValue.arrayUnion([event.productId]),
          });
          updatedCart.add(event.productId);
        }
        emit(CartLoadedState(updatedCart));
      }
      else{

        if(updatedCart.contains(event.productId)){
          updatedCart.remove(event.productId);
        }
        else{
          updatedCart.add(event.productId);
        }
        hiveCartBox.put('cart', updatedCart);
        emit(NotLoggedInState(updatedCart));
      }

      cart = List.from(updatedCart); // Update original list as well, if needed
      return;

    }catch(e){
      emit(CartErrorState("could not toggle cart : $e"));
    }
  }



}
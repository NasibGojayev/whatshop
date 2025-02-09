import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddCartEvent>(_onAddCart);
    on<DeleteCartEvent>(_onDeleteCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    _initialize();
  }

  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> cartProducts = [];

  late User? user;
  String? userId;
  DocumentReference? userRef;

  Future<void> _initialize() async {
    await _getUserData();
  }

  Future<void> _getUserData() async {
    user = await getCurrentUser();
    if (user != null) {
      userId = user!.uid;
      userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
    } else {
      //emit(CartErrorState("User is not logged in"));
    }
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      if (user == null) {
        emit(CartErrorState("User is not logged in"));
        return;
      }

      final DocumentSnapshot? userDoc = await userRef?.get();

      if (userDoc != null && userDoc.exists) {
        cartProducts.clear();
        cart.clear();
        final List<dynamic> cartData = userDoc['cart'];

        for (var cartItem in cartData) {
          String productId = cartItem['productId'] as String;
          int quantity = cartItem['quantity'] as int;

          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .where('id', isEqualTo: productId)
              .get()
              .then((value) => value.docs.first.data());

          cartProducts.add(productDoc);
          cart.add({
            'productId': productId,
            'quantity': quantity,
          });
        }
        emit(CartLoadedState(cart, cartProducts));
      } else {
        emit(CartErrorState("User document does not exist"));
      }
    } catch (e) {
      emit(CartErrorState("Error fetching the cart: $e"));
    }
  }

  Future<void> _onAddCart(AddCartEvent event, Emitter<CartState> emit) async {
    List<Map<String, dynamic>> addedCart = List.from(cart);
    List<Map<String, dynamic>> addedCartProducts = List.from(cartProducts);

    try {
      if (user != null) {
        bool productExists = addedCart.any((product) => product['productId'] == event.productId);

        if (productExists) {
          emit(CartLoadedState(addedCart, addedCartProducts));
          return;
        } else {
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .where('id', isEqualTo: event.productId)
              .get()
              .then((value) => value.docs.first.data());

          addedCart.add({
            'productId': event.productId,
            'quantity': 1,
          });

          await userRef!.update({
            'cart': addedCart,
          });

          addedCartProducts.add(productDoc);
          cart = List.from(addedCart);
          cartProducts = List.from(addedCartProducts);
          emit(CartLoadedState(addedCart, addedCartProducts));
        }
      } else {
        emit(CartErrorState("User is not logged in"));
      }
    } catch (e) {
      emit(CartErrorState("Could not add to cart: $e"));
    }
  }

  Future<void> _onDeleteCart(DeleteCartEvent event, Emitter<CartState> emit) async {
    List<Map<String, dynamic>> deletedCart = List.from(cart);
    List<Map<String, dynamic>> deletedCartProducts = List.from(cartProducts);

    try {
      if (user != null) {
        deletedCart.removeWhere((product) => product['productId'] == event.productId);
        deletedCartProducts.removeWhere((product) => product['id'] == event.productId);

        await userRef!.update({
          'cart': deletedCart,
        });

        cart = List.from(deletedCart);
        cartProducts = List.from(deletedCartProducts);
        emit(CartLoadedState(deletedCart, deletedCartProducts));
      } else {
        emit(CartErrorState("User is not logged in"));
      }
    } catch (e) {
      emit(CartErrorState("Could not delete from cart: $e"));
    }
  }


  Future<void> _onUpdateQuantity(
      UpdateCartQuantityEvent event,
      Emitter<CartState> emit,
      ) async {
    try {
      if (user != null) {
        // Create a copy of the current cart
        List<Map<String, dynamic>> updatedCart = List.from(cart);

        // Find the item to update
        final index = updatedCart.indexWhere(
                (item) => item['productId'] == event.productId
        );

        if (index != -1) {
          // Update the quantity
          updatedCart[index] = {
            'productId': event.productId,
            'quantity': event.quantity,
          };

          // Update Firestore
          await userRef!.update({'cart': updatedCart});

          // Update local state
          cart = updatedCart;

          // Find corresponding product in cartProducts
          final productIndex = cartProducts.indexWhere(
                  (product) => product['id'] == event.productId
          );

          // Emit new state with updated data
          emit(CartLoadedState(
            List.from(cart),
            List.from(cartProducts),
          ));
        }
      }
    } catch (e) {
      emit(CartErrorState("Could not update quantity: $e"));
    }
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoadingState()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddCartEvent>(_onAddCart);
    on<DeleteCartEvent>(_onDeleteCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    init();
  }

  List<Map<String, dynamic>> cart = [];
  List<Map<String, dynamic>> cartProducts = [];

 late User? user;
 late String userId;
 late SupabaseClient _supabase;

 void init(){

   _supabase = Supabase.instance.client;
   user = _supabase.auth.currentUser;

   if(user!=null){
     userId = user!.id;
   }
   else{
     print("user is null ");
   }
 }



  Future<void> _onAddCart(AddCartEvent event, Emitter<CartState> emit) async {


    List<Map<String, dynamic>> updatedCart = List<Map<String, dynamic>>.from(cart);
    List<Map<String, dynamic>> updatedCartProducts = List<Map<String, dynamic>>.from(cartProducts);

   if(updatedCartProducts.any((item)=>item['product_id']==event.product['product_id'])){
     print("item already exists");
     return;
   }

    updatedCart.add({
      'product_id': event.product['product_id'],
      'quantity': 1,
    });



    updatedCartProducts.add(event.product);


    try{
      await _supabase
          .from('users')
          .update({
        'cart': updatedCart,  // Update the cart with the new data
      }).eq('id', userId);

      print('Item appended successfully!');

      emit(CartLoadedState(updatedCart,updatedCartProducts));

    }catch(e){
      emit(CartErrorState("Couldn't add to cart: $e"));
    }

  }






  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    try{
      SupabaseClient _supabase = Supabase.instance.client;
      var result = await _supabase.from('users').select('cart').eq('id', userId).single();

      // Extract the 'cart' field from the result
      final cartData = result['cart'] as List<dynamic>;

      // Cast the cart data to List<Map<String, dynamic>>
      cart = cartData.cast<Map<String, dynamic>>();

      cartProducts = await _supabase.rpc('fn_get_products', params: {
         'user_id': userId,
       });
      print('nasib');

      emit(CartLoadedState(cart,cartProducts));


    }
    catch(e){
      print(e);
      emit(CartErrorState("Couldn't fetch the cart: $e"));
    }

  }



  Future<void> _onDeleteCart(DeleteCartEvent event, Emitter<CartState> emit) async {

    List<Map<String, dynamic>> updatedCart = List<Map<String, dynamic>>.from(cart);
    List<Map<String, dynamic>> updatedCartProducts = List<Map<String, dynamic>>.from(cartProducts);


   updatedCartProducts.removeWhere((item) => item['product_id'] == event.productId);
   updatedCart.removeWhere((item) => item['product_id'] == event.productId);

    await _supabase
        .from('users')
        .update({
      'cart': updatedCart,  // Update the cart with the new data
    }).eq('id', userId);



   emit(CartLoadedState(updatedCart,updatedCartProducts));
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
                (item) => item['product_id'] == event.productId
        );

        if (index != -1) {
          // Update the quantity
          updatedCart[index] = {
            'product_id': event.productId,
            'quantity': event.quantity,
          };

          await _supabase.rpc('update_cart_quantity', params: {
            'user_id': userId,
            'product_id': event.productId,
            'new_quantity': event.quantity,
          });

          // Update local state
          cart = updatedCart;

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



  /*Future<void> _onUpdateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    try {

      List<Map<String, dynamic>> updatedCart = List<Map<String, dynamic>>.from(cart);
      List<Map<String, dynamic>> updatedCartProducts = List<Map<String, dynamic>>.from(cartProducts);


      final itemIndex = cart.indexWhere((item) => item['product_id'] == event.productId);
      if (itemIndex == -1) {
        emit(CartErrorState("Product not found in cart"));
        return;
      }


      updatedCart[itemIndex]['quantity'] = event.quantity;

      // Update the quantity in the database
      await _supabase.rpc('update_cart_quantity', params: {
        'user_id': userId,
        'product_id': event.productId,
        'new_quantity': event.quantity,
      });

      print('Cart quantity updated successfully');

      // Emit the updated state
      emit(CartLoadedState(updatedCart, updatedCartProducts));


    } catch (e) {
      emit(CartErrorState("Could not update quantity: $e"));
    }
  }*/
}


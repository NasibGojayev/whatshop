import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../d_product_bloc/d_product_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final SupabaseClient _supabase;
  CartBloc(this._supabase) : super(CartLoadingState()) {
    on<FetchCartEvent>(_onFetchCart);
    on<AddCartEvent>(_onAddCart);
    on<DeleteCartEvent>(_onDeleteCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    on<ToggleSelectedEvent>(_onToggleSelected);
    init();
  }

  List<CartItem> cart = [];
   User? user;
   String? userId;
   String? userName;

  bool isFetched = false;

  void init() {
    user = _supabase.auth.currentUser;
    if (user != null) {
      userId = user!.id;
      userName = user!.userMetadata?['username'];

      add(FetchCartEvent());
    }
  }

  Future<void> _onFetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());

    try {
      double total = 0;
      // Fetch user cart data
      final response = await _supabase.from('users').select('cart').eq('id', userName!).single();
      final List<dynamic> cartData = response['cart'] ?? [];
      if (cartData.isEmpty) {
        emit(CartEmptyState());
        return;
      }

      // Fetch product details using RPC
      final List<Product> cartProducts =[];
      //List<String> productIds = cartData.map((item) => item['product_id'] as String).toList();
      //var json = await _supabase.from('products').select().inFilter('product_id', productIds);


      var json = await _supabase.rpc('f_get_products', params: {
        'user_id': userName,
      });

      for(var item in json){
        cartProducts.add(
            getProductFromJson(item)
        );
      }

      // Create the cart list by matching cart items with product details
      cart.clear(); // Clear existing cart before adding fresh data
      for (var product in cartProducts) {
        final matchingCartItem = cartData.firstWhere(
              (item) => item['product_id'] == product.productId,
          orElse: () => null,
        );

        bool isAvailable = false;
        if(product.sizeOptions.firstWhere((element) => element.size == matchingCartItem['size']).isAvailable
            && product.colorOptions.firstWhere((element) => element.color == matchingCartItem['color']).isAvailable){
          isAvailable = true;
        }
        if (matchingCartItem != null) {
          cart.add(CartItem(
            sizeOption: SizeOption(
                price: product.sizeOptions.firstWhere((element) => element.size == matchingCartItem['size']).price,
                size: matchingCartItem['size'],
                isAvailable: product.sizeOptions.firstWhere((element) => element.size == matchingCartItem['size']).isAvailable) ,
            colorOption: ColorOption(
                color: matchingCartItem['color'] as String,
                isAvailable: product.colorOptions.firstWhere((element) => element.color == matchingCartItem['color']).isAvailable),
            quantity: matchingCartItem['quantity'] as int,
            isSelected: isAvailable?true:false,
            name: product.name,
            image: product.images.isNotEmpty == true ? product.images[0] :'',
            productId: product.productId,
            
          ));
        }
      }

      isFetched = true;
      for(var item in cart){
        if(item.isSelected){
          total+=item.sizeOption.price*item.quantity;
        }
      }
      emit(CartLoadedState(List.from(cart),total)); // Emit cart with products
    } catch (e, stackTrace) {
      debugPrint('Fetch cart error: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(CartErrorState("Couldn't fetch the cart: $e"));
    }
  }

  Future<void> _onAddCart(AddCartEvent event, Emitter<CartState> emit) async {
    // Fetch cart only once
    if (!isFetched) {
      await _onFetchCart(FetchCartEvent(), emit);
    }

    // Check if item already exists in cart
    if (cart.any((item) => item.productId == event.product.productId)) {
      debugPrint("Item already exists in cart.");
      return;
    }

    // Add new item to cart
    // is availabilityni burada true verirem , zaten eger karta atmisamsa true-dur.
    // eger elcatan deyilse bu detailed product page de gorunecek


    final newItem = CartItem(
      sizeOption: SizeOption(
          price: event.sizeOption.price,
          size: event.sizeOption.size,
          isAvailable: true),
      colorOption: ColorOption(
          color: event.colorOption.color,
          isAvailable: true),
      name: event.product.name,
      image: event.product.images[0],
      productId: event.product.productId,
      quantity: 1,
      isSelected: true,
    );

    cart.add(newItem);
    debugPrint('${event.product.productId} added to cart');

    try {
      await _supabase.from('users').update({
        'cart': cart.map((e) => e.forDb()).toList(),
      }).eq('id', userName!);
      double total = 0;

      for(var item in cart){
        if(item.isSelected){
          total +=item.sizeOption.price*item.quantity;
        }
      }

      emit(CartLoadedState(List.from(cart),total)); // Emit updated cart
    } catch (e) {
      emit(CartErrorState("Couldn't add to cart: $e"));
    }
  }
//-----------------------------------------
  Future<void> _onDeleteCart(DeleteCartEvent event, Emitter<CartState> emit) async {
    double total = 0;
    cart.removeWhere((item) => item.productId == event.productId);

    try {
      await _supabase.from('users').update({
        'cart': cart.map((e) => e.forDb()).toList(),
      }).eq('id', userName!);
      for(var item in cart){
        if(item.isSelected){
          total +=item.sizeOption.price*item.quantity;
        }
      }
      if(cart.isEmpty){
        emit(CartEmptyState());
        return;
      }
      else{
        emit(CartLoadedState(List.from(cart),total)); // Emit updated cart after removal
      }
    } catch (e) {
      emit(CartErrorState("Couldn't delete from cart: $e"));
    }
  }

  Future<void> _onUpdateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    try {
      double total = 0;
      emit(CartUpdatingQuantityState(List.from(cart), event.productId,total));

      final index = cart.indexWhere((item) => item.productId == event.productId);
      if (index != -1) {
        cart[index].quantity = event.quantity;

        await _supabase.rpc('update_cart_quantity', params: {
          'user_id': userName!,
          'product_id': event.productId,
          'new_quantity': event.quantity,
        });

        await _supabase.from('users').update({
          'cart': cart.map((e) => e.forDb()).toList(),
        }).eq('id', userName!);
        for(var item in cart){
          if(item.isSelected){
            total +=item.sizeOption.price*item.quantity;
          }
        }
        emit(CartLoadedState(List.from(cart),total)); // Emit updated cart after quantity change
      }
    } catch (e) {
      emit(CartErrorState("Couldn't update quantity: $e"));
    }
  }

  Future<void> _onToggleSelected(ToggleSelectedEvent event, Emitter<CartState> emit) async {
    try {
      double total = 0;
      emit(CartLoadingState());

      final itemIndex = cart.indexWhere((item) => item.productId == event.productId);
      if (itemIndex != -1) {
        cart[itemIndex].isSelected = !cart[itemIndex].isSelected;

        await _supabase.from('users').update({
          'cart': cart.map((e) => e.forDb()).toList(),
        }).eq('id', userName!);
      }
      for(var item in cart){
        if(item.isSelected){
          total +=item.sizeOption.price*item.quantity;
        }
      }
      emit(CartLoadedState(List.from(cart),total)); // Emit updated cart after toggle
    } catch (e) {
      emit(CartErrorState("Couldn't update selection: $e"));
    }
  }
}

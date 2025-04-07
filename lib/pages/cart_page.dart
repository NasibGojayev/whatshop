import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_state.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_events.dart';
import 'package:whatshop/pages/check_out_1.dart';
import 'package:whatshop/pages/first_page.dart';
import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';

import '../bloc_management/favorite_bloc/favorite_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import 'detailed_product_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return  Scaffold(
      appBar: AppBar(
        title: const Text("Səbət"),
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              context.go('/home');
            },
            child: Icon(Icons.arrow_back_ios_new)),
      ),
      body: Center(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState is CartLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            else if (cartState is CartErrorState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cartState.error),
                  ElevatedButton(
                    onPressed: () => context.read<CartBloc>().add(FetchCartEvent()),
                    child: const Text("Yenidən yüklə"),
                  ),
                ],
              );
            }
            else if (cartState is CartLoadedState || cartState is CartUpdatingQuantityState) {
              List<CartItem> cart;
              if (cartState is CartLoadedState) {
                cart = (cartState).cart;
              } else {
                cart = (cartState as CartUpdatingQuantityState).cart;
              }
              final updatingProductId = cartState is CartUpdatingQuantityState ? cartState.updatingProductId : null;
              double cargo = 3.5;
              double total = cartState is CartLoadedState ? cartState.total : 0;
              if(total>=30){
                cargo = 0;
              }
              if(total==0){
                cargo=0;
              }
              else{
                total = total + cargo;
              }
              return Column(
                children: [
                  Container(
                    width: widthSize*0.95,
                    height: 50,
                    child: total>=30?
                    Center(child: Text('Pulsuz çatdırılma əldə etdiniz ',)):
                        Center(child: Row(
                          children: [
                            CircularProgressIndicator(
                              value: (total-3.5)/30,
                              color: Colors.black54,
                              strokeWidth: 1,
                            ),
                            Text('  Pulsuz çatdırıma üçün ${total!=0?(30+3.5-total):(30).toStringAsFixed(2)} AZN məhsul əlavə edin'),
                          ],
                        ))


                  ),
                  Expanded(
                    child: SizedBox(
                      width: widthSize,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 12),
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final cartItem = cart[index];
                          final isUpdating = cartItem.productId == updatingProductId;

                          return CartItemWidget(cartItem: cartItem, isUpdating: isUpdating);
                        },
                      ),
                    ),
                  ),
                  Container(
                      width: widthSize,
                      height: 60,
                      decoration: BoxDecoration(
                        color: bozumsu,
                        border: Border(
                          top: BorderSide(
                            color: Colors.black54
                          )
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent, // Remove default background
                                builder: (context) => Container(
                                  height: 200,
                                  width: widthSize, // Fixed width
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(blurRadius: 10, color: Colors.black12),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text('Ödənəcək məbləğ'),
                                      ),
                                      // Your content...
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Məhsul Toplamı'),
                                              cartState is CartLoadedState ?
                                              Text('${cartState.total.toStringAsFixed(2)} AZN',style:TextStyle(
                                                color: primaryTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),):
                                              CircularProgressIndicator(),


                                            ]
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Çatdırılma'),
                                              Text('$cargo AZN',style:TextStyle(
                                                color: primaryTextColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ))


                                            ]
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.keyboard_arrow_up),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Ödənəcək məbləğ'),
                                    cartState is CartLoadedState ?
                                    Text(total.toStringAsFixed(2),style:TextStyle(
                                      color: primaryTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),):
                                    CircularProgressIndicator(),
                                  ],
                                )
                              ],
                            ),
                          )
                          ,
                          SizedBox(width: 6,),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: Container(
                                  color: primaryColor,
                                  child: Center(child: Text('Alış-verişi tamamla',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                ],
              );
            }
            else if(cartState is CartEmptyState){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      child: Image.asset('assets/images/cart.png')),
                  Text(
                      'Səbətdə məhsul yoxdur',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3,),
                  Text(
                      "Alış-verişə dərhal başla , sərfəli məhsulları qaçırma",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 60,
                    width: widthSize*0.95,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          context.go('/home');
                        },
                        child: Container(
                          color: primaryColor,
                          child: Center(child: Text('Alış-verişə başla',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                ]
              );
            }
            else {
              return const Center(child: Text("Xəta baş verdi"));
            }
          },
        ),
      ),
    );

  }
}
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final bool isUpdating;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
    this.isUpdating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: bozumsu,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              context.read<CartBloc>().add(ToggleSelectedEvent(cartItem.productId));
            },
            icon: Icon(
              cartItem.isSelected ? Icons.check_box : Icons.check_box_outline_blank,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/product/${cartItem.productId}'),
            child: Image.network(
              cartItem.image,
              width: 100,
              height: 170,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            cartItem.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        BlocBuilder<FavoriteBloc, FavoriteStates>(
                          builder: (context, state) {
                            bool isFavorite = false;
                            if (state is FavoriteUpdatedState) {
                              isFavorite = state.updatedFavorites.any((fav) => fav.productId == cartItem.productId);
                            }
                            return Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                              color: primaryColor,
                              size: 24,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${cartItem.sizeOption.price} AZN',
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Seçim: '),
                      Text('${cartItem.colorOption.color}/${cartItem.sizeOption.size}',style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),)
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (cartItem.quantity == 1) {
                            context.read<CartBloc>().add(DeleteCartEvent(cartItem.productId));
                          } else {
                            context.read<CartBloc>().add(UpdateCartQuantityEvent(
                              productId: cartItem.productId,
                              quantity: cartItem.quantity - 1,
                            ));
                          }
                        },
                        child: Icon(
                          cartItem.quantity == 1 ? Icons.delete : Icons.remove,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 3),
                      isUpdating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('Ədəd ${cartItem.quantity}'),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {
                          context.read<CartBloc>().add(UpdateCartQuantityEvent(
                            productId: cartItem.productId,
                            quantity: cartItem.quantity + 1,
                          ));
                        },
                        child: Icon(Icons.add, color: primaryTextColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*Widget _buildCartItem(BuildContext context, Map<String, dynamic> product,
      VoidCallback onDelete) {
    return ListTile(
      leading: TextButton(
          onPressed: () {
            context.push('/product/${product['id']}');
          },
          child: Image.network('${product['pic_path'][0]}', width: 70)),
      title: Text('${product['name']}'),
      subtitle: Text('${product['price']} AZN'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_state.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/pages/check_out_1.dart';
import 'package:whatshop/pages/first_page.dart';
import 'package:whatshop/tools/variables.dart';

import 'detailed_product_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Səbətdəki məhsullar"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState is CartLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (cartState is CartErrorState) {
                    return Column(
                      children: [
                        Center(child: Text(cartState.error)),
                        ElevatedButton(
                            onPressed: () {
                              context.read<CartBloc>().add(FetchCartEvent());
                            },
                            child: const Text("Yenidən yüklə"))
                      ],
                    );
                  } else if (cartState is CartLoadedState) {
                    return SizedBox(
                      width: widthSize * 0.8,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.grey, height: 40),
                        itemCount: cartState.cartProducts.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> product =
                              cartState.cartProducts[index];
                          Map<String, dynamic> cartItem = cartState.cart[index];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: _buildCartItem(context, product, () {
                                  context.read<CartBloc>().add(
                                      DeleteCartEvent(product['product_id']));
                                }),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<CartBloc>().add(UpdateCartQuantityEvent(
                                            productId: cartState.cart[index]['product_id'],
                                            quantity: cartItem['quantity'] + 1,
                                          ));
                                    },
                                    icon: const Icon(
                                        Icons.add_circle_outline_outlined,
                                        size: 20),
                                  ),
                                  Text(
                                    '${cartItem['quantity']}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Decrement quantity
                                      if (cartItem['quantity'] > 1) {
                                        context
                                            .read<CartBloc>()
                                            .add(UpdateCartQuantityEvent(
                                              productId: cartItem['product_id'],
                                              quantity:
                                                  cartItem['quantity'] - 1,
                                            ));
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.remove_circle_outline_outlined,
                                        size: 20),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text("Xeta bas verdi"));
                },
              ),
            ),
            GetStarted(clicked: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOut1()));
            }, width: widthSize*0.9, height: 70,insideText: 'Sifarisi Resmilesdir',)
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Map<String, dynamic> product,
      VoidCallback onDelete) {
    return ListTile(
      leading: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailedProductPage(
                          product: product,
                        )));
          },
          child: Image.network('${product['pic_path'][0]}', width: 70)),
      title: Text('${product['name']}'),
      subtitle: Text('${product['price']} AZN'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}

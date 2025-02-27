import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_state.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
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
                    return Center(child: Text(cartState.error));
                  } else if (cartState is CartLoadedState) {
                    return _buildCartItems(context, cartState, widthSize);
                  }
                  return const Center(child: Text("Xeta bas verdi"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, CartLoadedState cartState, double widthSize) {
    return SizedBox(
      width: widthSize * 0.8,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(color: Colors.grey, height: 40),
        itemCount: cartState.cartProducts.length,
        itemBuilder: (context, index) {
          var product = cartState.cartProducts[index];
          var cartItem = cartState.cart[index];

          return Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: _buildCartItem(context , product, () {
                  context.read<CartBloc>().add(DeleteCartEvent(product['id']));
                }),
              ),
              _buildQuantityControls(context, cartItem),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context ,Map<String, dynamic> product, VoidCallback onDelete) {
    return ListTile(
      leading: TextButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailedProductPage(product: product,)));
        },
          child: Image.network(product['picPath'],width: 70)) ,
      title: Text(product['name']),
      subtitle: Text('${product['price']} AZN'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context, Map<String, dynamic> cartItem) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            // Increment quantity
            context.read<CartBloc>().add(UpdateCartQuantityEvent(
              productId: cartItem['productId'],
              quantity: cartItem['quantity'] + 1,
            ));
          },
          icon: const Icon(Icons.add_circle_outline_outlined, size: 20),
        ),
        Text(
          '${cartItem['quantity']}',
          style: const TextStyle(fontSize: 20),
        ),
        IconButton(
          onPressed: () {
            // Decrement quantity
            if (cartItem['quantity'] > 1) {
              context.read<CartBloc>().add(UpdateCartQuantityEvent(
                productId: cartItem['productId'],
                quantity: cartItem['quantity'] - 1,
              ));
            }
          },
          icon: const Icon(Icons.remove_circle_outline_outlined, size: 20),
        ),
      ],
    );
  }
}

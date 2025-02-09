import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_state.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/sign_in.dart';
import 'package:whatshop/Auth/signed_in_user.dart';
import 'package:whatshop/tools/variables.dart';
import 'package:whatshop/pages/category_page.dart';
import 'package:whatshop/pages/home_page.dart';

import 'detailed_product_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sebet"),
      ),
      body: SafeArea(
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
            BottomPanel(widthSize: widthSize),
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
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => DetailedProductPage(productId: product['id']))),
                  child: _buildCartItem(product, () {
                    context.read<CartBloc>().add(DeleteCartEvent(product['id']));
                  }),
                ),
              ),
              _buildQuantityControls(context, cartItem),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> product, VoidCallback onDelete) {
    return Item(id: product['id'], icon: Icon(Icons.delete_outline_outlined, size: 30,color: Colors.red,), onPressed: onDelete, image: Image.asset(product['picPath']), name: product['name'], price: product['price']);
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
          icon: const Icon(Icons.add_circle_outline_outlined, size: 30),
        ),
        Text(
          '${cartItem['quantity']}',
          style: const TextStyle(fontSize:40),
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
          icon: const Icon(Icons.remove_circle_outline_outlined, size: 30),
        ),
      ],
    );
  }
}

class BottomPanel extends StatelessWidget {
  final double widthSize;
  const BottomPanel({super.key, required this.widthSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthSize,
      height: 73,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomIcon(context, Icons.home_filled, () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()))),
          _buildBottomIcon(context, Icons.category, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()))),
          _buildBottomIcon(context, Icons.shopping_cart, () {}),
          _buildBottomIcon(context, Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AuthRepository.isSignedIn
                    ? const SafeArea(child: Scaffold(body: SignedInUser()))
                    : Scaffold(body: SafeArea(child: SingleChildScrollView(child: SecondPage()))),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: widthSize * 0.22,
      height: 73,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
      ),



    );
  }
}
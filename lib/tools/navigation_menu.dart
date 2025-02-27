import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/signed_in_user.dart';
import '../pages/cart_page.dart';
import '../pages/category_page.dart';
import '../pages/favorite_page.dart';
import '../pages/home_page.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          bottomNavigationBar: BlocBuilder<NavigatorCubit,int>(
              builder: (context,state) {
              return NavigationBar(
                  height: 80,
                  elevation: 0,
                  selectedIndex: state,
                  onDestinationSelected: (index) =>
                      context.read<NavigatorCubit>().changeIndex(index),
                  destinations: const[
                    NavigationDestination(icon: Icon(Icons.home), label: 'Əsas'),
                    NavigationDestination(
                        icon: Icon(Icons.category), label: 'Kategoriya'),
                    NavigationDestination(icon: Icon(Icons.share), label: 'Paylaş'),
                    NavigationDestination(
                        icon: Icon(Icons.shopping_cart), label: 'Səbət'),
                    NavigationDestination(
                        icon: Icon(Icons.person), label: 'Profil'),
                  ]
              );
            }
          ),
          body: BlocBuilder<NavigatorCubit,int>(
            builder: (context,state) {
              return context.read<NavigatorCubit>().pages[state];
            }
          ),
        );
  }
}

class NavigatorCubit extends Cubit<int>{
  NavigatorCubit():super(0);
  void changeIndex(int index){
    emit(index);
  }
  final pages = [
    HomePage(),
    const CategoryPage(),
     FavoritePage(),
    const CartPage(),
    const SignedInUser(),
  ];
}

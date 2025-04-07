import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/Auth/auth_gate.dart';
import 'package:whatshop/pages/cart_page.dart';
import 'package:whatshop/pages/category_page.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/pages/favorite_page.dart';
import 'package:whatshop/pages/signed_in_user.dart';
import '../pages/home_page.dart';
import 'navigation_menu.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: AuthGate()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: HomePage(),)),
    ),
    GoRoute(
      path: '/category',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: CategoryPage(),)),
    ),
    GoRoute(
      path: '/favorite',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: FavoritePage(),)),
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) => const MaterialPage(child:NavigationMenu(child: CartPage(),)),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const MaterialPage(child:NavigationMenu(child: SignedInUser(),)),
    ),
    GoRoute(
      path: '/product/:id',
      pageBuilder: (context, state) {
        final productId = state.pathParameters['id'];
        return MaterialPage(child: DetailedProductPage(productId: productId!));
      },
    ),
  ],
);

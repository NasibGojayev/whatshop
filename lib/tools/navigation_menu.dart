import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'colors.dart';

class NavigationMenu extends StatelessWidget {
  final Widget child; // <-- This is the page rendered
  const NavigationMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).state.matchedLocation;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: _calculateSelectedIndex(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/category');
              break;
            case 2:
              context.go('/favorite');
              break;
            case 3:
              context.go('/cart');
              break;
            case 4:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Əsas'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Kategori'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Sevimli'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Səbət'),
          NavigationDestination(icon: Icon(Icons.manage_accounts), label: 'Profil'),
        ],
      ),
      body: child,
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/category')) return 1;
    if (location.startsWith('/favorite')) return 2;
    if (location.startsWith('/cart')) return 3;
    if (location.startsWith('/profile')) return 4;

    return 0;
  }
}

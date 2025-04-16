import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/Auth/auth_gate.dart';
import 'package:whatshop/pages/order_related/cart_page.dart';
import 'package:whatshop/pages/category_page.dart';
import 'package:whatshop/pages/order_related/check_out_1.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/pages/favorite_page.dart';
import 'package:whatshop/pages/profile_pages/about.dart';
import 'package:whatshop/pages/profile_pages/sign_up.dart';
import 'package:whatshop/pages/profile_pages/support.dart';
import 'package:whatshop/pages/profile_pages/user_details.dart';
import '../pages/order_related/check_out_2.dart';
import '../pages/error_page.dart';
import '../pages/first_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_pages/contact_us.dart';
import '../pages/profile_pages/profile_page.dart';
import '../pages/profile_pages/sign_in.dart';
import '../pages/vendor_profile.dart';
import 'navigation_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final GoRouter router = GoRouter(
  errorBuilder: (context, state) => MaterialApp(
      home: const ErrorPage(
        path: 'Xəta',
      )),
  initialLocation: '/',
  redirect: (context, state) {

    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;

    const protectedPaths = ['/cart', '/favorite', '/profile','/home'];

    if (!isLoggedIn && protectedPaths.contains(state.matchedLocation)) {
      return '/'; // ana səhifəyə yönləndir
    }
    if(!isLoggedIn) return '/sign_in';
    if (isLoggedIn && ['/', '/sign_in', '/sign_up'].contains(state.matchedLocation)) {
      return '/'; // Redirect to app
    }

    // başqa heç nəyə qarışma
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(child: AuthGate()),
    ),
    GoRoute(
      path: '/first_page',
      pageBuilder: (context, state) => MaterialPage(child: FirstPage()),
    ),
    GoRoute(
      path: '/sign_up',
      pageBuilder: (context, state) => MaterialPage(child: SignUp()),
    ),
    GoRoute(
      path: '/sign_in',
      pageBuilder: (context, state) => MaterialPage(child: WelcomePage()),
    ),
    //--------------------------------
    GoRoute(
      path: '/user_details',
      pageBuilder: (context, state) => MaterialPage(child: UserDetails()),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) => MaterialPage(child: AboutPage()),
    ),
    GoRoute(
      path: '/contact_us',
      pageBuilder: (context, state) => MaterialPage(child: ContactUsScreen()),
    ),
    GoRoute(
      path: '/support',
      pageBuilder: (context, state) => MaterialPage(child: SupportScreen()),
    ),
//------------------------------------------


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
      path: '/checkout1',
      pageBuilder: (context, state) => MaterialPage(child: CheckOut1()),
    ),
    GoRoute(
      path: '/checkout2',
      pageBuilder: (context, state) => MaterialPage(child: NavigationMenu(child: CheckOut2(),)),
    ),
    GoRoute(
      path: '/cart',
      pageBuilder: (context, state) => const MaterialPage(child:NavigationMenu(child: CartPage(),)),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const MaterialPage(child:NavigationMenu(child: ProfilePage(),)),
    ),
    GoRoute(
      path: '/product/:id',

      pageBuilder: (context, state) {
        final productId = state.pathParameters['id'];
        return MaterialPage(child: DetailedProductPage(productId: productId!));
      },
    ),
    GoRoute(
      path: '/vendor/:id',

      pageBuilder: (context, state) {
        final vendorId = state.pathParameters['id'];
        return MaterialPage(child: VendorProfilePage(vendorId: vendorId!));
      },
    ),
    GoRoute(
      path: '/:path(.*)', // Matches any invalid path
      pageBuilder: (context, state) => MaterialPage(
        child: ErrorPage(
          path: 'Xəta oldu: whatshop.az/${state.uri.path}',
        ),
      ),
    ),


  ],
);

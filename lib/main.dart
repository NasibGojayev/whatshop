import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';
import 'package:whatshop/bloc_management/address_bloc/address_event.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_event.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/bloc_management/user_bloc/user_bloc.dart';
import 'package:whatshop/bloc_management/user_bloc/user_event.dart';
import 'package:whatshop/pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'bloc_management/favorite_bloc/favorite_bloc.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<List<String>>('favorites');
  await Hive.openBox<List<String>>('cart');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );





  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>UserBloc()..add(FetchUserEvent())),
        BlocProvider(create: (_)=>ProductBloc()..add(FetchByCategoryEvent("0"))),
        BlocProvider(create: (_)=>FavoriteBloc()..add(FetchFavoritesEvent())),
        BlocProvider(create: (_)=>AddressBloc()..add(FetchAddressEvent())),
        BlocProvider(create: (_)=>CartBloc()..add(FetchCartEvent())),
        BlocProvider(create: (_)=>CategoryBloc()..add(FetchCategories()))
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        // Listen to auth state changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while checking auth state
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text('Giris statusunu yoxlayarken xeta bas verdi')),
            );
          } else if (snapshot.hasData) {
            // User is signed in
            AuthRepository.isSignedIn = true;
            return HomePage();
          } else {
            // No user is signed in
            return Scaffold(
              body: HomePage(),
            );
          }
        },
      ),
    );
  }
}

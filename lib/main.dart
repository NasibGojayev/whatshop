import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/sign_in.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_event.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/pages/first_page.dart';
import 'package:whatshop/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:whatshop/provider_classes/user_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc_management/favorite_bloc/favorite_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_)=>ProductBloc()..add(FetchProductsEvent())),
        BlocProvider(create: (_)=>FavoriteBloc()..add(FetchFavoritesEvent())),

        ChangeNotifierProvider(create: (_) => UserDetails()),
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
              body: FirstPage(),
            );
          }
        },
      ),
    );
  }
}

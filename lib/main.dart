import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/comment_bloc/comment_bloc.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/bloc_management/user_bloc/user_bloc.dart';
import 'package:whatshop/tools/router.dart';
import 'package:whatshop/tools/variables.dart';
import 'bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'bloc_management/favorite_bloc/favorite_events.dart';
import 'bloc_management/rating_cubit/rating_cubit.dart';
import 'bloc_management/vendor_cubit/vendor_cubit.dart';

void main() async {



  final stopwatch = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('Binding time: ${stopwatch.elapsedMilliseconds}ms');

  await Hive.initFlutter();
  debugPrint('Hive init time: ${stopwatch.elapsedMilliseconds}ms');

  await Supabase.initialize(url: url, anonKey: anonKey);
  debugPrint('Supabase init time: ${stopwatch.elapsedMilliseconds}ms');

  // Open a box (this will create a local storage for user data)
  await Hive.openBox('userAddresses');
  await Hive.openBox('favorites');
  WidgetsFlutterBinding.ensureInitialized();





  final SupabaseClient supabase = Supabase.instance.client;



  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>VendorCubit()),
        BlocProvider(create: (_)=>CommentBloc(supabase)),
        BlocProvider(create: (_)=>UserBloc()),
        BlocProvider(create: (_)=>FavoriteBloc(supabase)..add(FetchFavoriteEvent())),
        BlocProvider(create: (_)=>RatingCubit(supabase)),
        BlocProvider(create: (_)=>ProductIdBloc(supabase)),
        BlocProvider(create: (_)=>ProductBloc()..add(FetchByCategoryEvent("0"))),
        BlocProvider(create: (_)=>CartBloc(supabase)..add(FetchCartEvent())),
        BlocProvider(create: (_)=>AddressBloc()),
        BlocProvider(create: (_)=>CategoryBloc()..add(FetchCategories()))
      ],
      child: MyApp(),
    ),
  );
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CartBloc>().add(FetchCartEvent());
    return MaterialApp.router(
      title: 'WhatShop',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
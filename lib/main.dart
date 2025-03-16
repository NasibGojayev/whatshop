import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:whatshop/Auth/auth_gate.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';
import 'package:whatshop/bloc_management/address_bloc/address_event.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_cubit.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/bloc_management/user_bloc/user_bloc.dart';
import 'package:whatshop/bloc_management/user_bloc/user_event.dart';
import 'package:whatshop/tools/navigation_menu.dart';
import 'bloc_management/favorite_bloc/share_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {

  // Initialize Hive
  await Hive.initFlutter();

  // Open a box (this will create a local storage for user data)
  await Hive.openBox('userAddresses');



  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lwdszubkpfrnyduswzfs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3ZHN6dWJrcGZybnlkdXN3emZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA0MzE4NjEsImV4cCI6MjA1NjAwNzg2MX0.gcDrC8YPB3G_kRqHYZd54QBFJJqI1J17O4zrisrm73Q',
  );


  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>UserBloc()..add(FetchUserEvent())),
        BlocProvider(create: (_)=>FavoriteCubit()),
        BlocProvider(create: (_)=>ShareCubit()),
        BlocProvider(create: (_)=>NavigatorCubit()),
        BlocProvider(create: (_)=>ProductBloc()..add(FetchByCategoryEvent("0"))),
        BlocProvider(create: (_)=>CartBloc()..add(FetchCartEvent())),
        BlocProvider(create: (_)=>AddressBloc()..add(FetchAddressEvent())),
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
      title: 'WhatShop',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: AuthGate()
    );
  }
}

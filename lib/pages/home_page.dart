import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/pages/cart_page.dart';
import 'package:whatshop/tools/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/signed_in_user.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_state.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop/pages/category_page.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/Auth/sign_in.dart';

import '../bloc_management/favorite_bloc/favorite_event.dart';
import '../tools/colors.dart';

class HomePage extends StatelessWidget {


  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();

  void scrollControllerListener(){
    if(scrollController.offset>=scrollController.position.maxScrollExtent
    && !scrollController.position.outOfRange){

    }
  }

  @override

  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);
    //double heightSize = getHeightSize(context);
    int crossAxisCount = getCrossAxisCount(context);
    double childAspectRatio = getChildAspectRatio(context);
    String categoryId = "0";
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Column(
            children: [
              appBar(),
              Center(child: SearchBar(
                controller: searchController,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  searchController.openView();
                },
                onChanged: (_) {
                  searchController.openView();
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[
                  Tooltip(
                    message: 'Change brightness mode',
                    child: IconButton(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.wb_sunny_outlined),
                      selectedIcon: const Icon(Icons.brightness_2_outlined),
                    ),
                  )
                ],
              )),
              Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 40,
                      child: BlocBuilder<CategoryBloc,CategoryState>(
                        builder: (context,state) {
                          if(state is CategoryLoaded){
                            return ListView.builder(
                              itemCount: state.categories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){

                                return Category(
                                  textColor: state.selectedIndex==index?Colors.white:Colors.black,
                                  color: state.selectedIndex==index?Color(0xFF25D366):bozumsu,
                                  name: "${state.categories[index]['name']}",
                                  onPressed: (){
                                    categoryId = state.categories[index]['id'];
                                    context.read<CategoryBloc>().add(SetSelectedIndex(index));
                                    context.read<ProductBloc>().add(FetchByCategoryEvent(categoryId));
                                  },
                                );
                              }
                              ,
                            );
                          }
                          else {

                            return LinearProgressIndicator();
                          }

                        }
                      ),
                    ),
                  ),
              Expanded(

                  child: BlocConsumer<ProductBloc,ProductState>(
                        listener: (context,state){},
                        builder: (context,state) {
                          if(state is ProductLoadedState){
                            return GridView.builder(
                              controller: scrollController,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: childAspectRatio
                              ),
                              itemCount: state.products.length,
                              itemBuilder: (context, index) {

                                final product = state.products[index];

                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder:
                                        (context)=>DetailedProductPage(
                                      productId: product['id'],)));
                                  },
                                  child:  Item(
                                          id: product['id'],
                                          onPressed: (){
                                            context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product['id']));
                                          },
                                          image: Image.asset(product['picPath']),
                                          name: product['name'],
                                          price: product['price'],
                                          icon: BlocBuilder<FavoriteBloc,FavoriteState>(
                                              builder: (context,state){
                                                if(state is FavoriteLoadedState){
                                                 return state.favorites.contains(product['id'])
                                                      ? SvgPicture.asset('assets/icons/hearted.svg')
                                                      : SvgPicture.asset('assets/icons/unhearted.svg');
                                                }
                                                else if(state is FavoriteLoadingState){
                                                  return Center(child: CircularProgressIndicator(),);
                                                }
                                                else{
                                                  return Text("error");
                                                }
                                              }),
                                       )


                                );
                              },
                            );
                          }
                          else if(state is ProductLoadingState){
                            return Center(child: CircularProgressIndicator());
                          }else if(state is ProductErrorState){
                            return ScaffoldMessenger(child: SnackBar(content: Text('there is an error fetching products')));
                          }
                          else if(state is EndOfProductsState) {
                            print(state);
                            return Center(child: Text('Heleki mehsul yoxdur , gozlemede qalin ✨'),);
                          }
                          else{
                            print(state);
                            return Center(child: Text('Gozlenilmeyen xeta bas verdi'),);
                          }
                        }
                      )

              ),

              Container(

                width: widthSize,
                height: 73,
                child: BottomPanel(widthSize: widthSize),
              )
            ],

          )),
      );
  }




  Container appBar() {
    return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/logo.svg"),
                    SizedBox(width: 11,),
                    Text(
                      'WhatShop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1D1E20),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0.04,
                        letterSpacing: -0.21,
                      ),
                    ),
                  ],
                ),
              ),
            );
  }
}

class Item extends StatelessWidget {

  final Image image;
  final String id;
  final String name;
  final num price;
  final Widget icon;
  final VoidCallback onPressed;
  const Item({
    super.key,
    required this.id,
    required this.icon,
    required this.onPressed,
    required this.image,
    required this.name,
    required this.price,

  });



  @override
  Widget build(BuildContext context) {
    //double widthSize = MediaQuery.of(context).size.width;
    //double heightSize = MediaQuery.of(context).size.height;
    return Container(
      color: bozumsu, // Light grey background
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow content to grow naturally
        children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: onPressed, icon: icon)),

          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge, // Clip content to fit within rounded corners
            child: image,
          ),
          SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.45),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "$price AZN", // Assuming price is a double value, adding a '$' symbol
            style: TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final String name;
  const Category({
    super.key,
    required this.color,
    required this.name,
    required this.onPressed,
    required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(left: 15),
      width: 100,
      height: 40,

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20)
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,

            fontSize: 14,
            fontFamily: 'NATS',
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0,
          ),
        ),
      ),
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
          _buildBottomIcon(context, Icons.home_filled, () {}),
          _buildBottomIcon(context, Icons.category, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()))),
          _buildBottomIcon(context, Icons.shopping_cart, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
          }),
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



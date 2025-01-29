import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop/pages/category_page.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/Auth/sign_in.dart';

import '../bloc_management/favorite_bloc/favorite_event.dart';
import '../tools/colors.dart';

class HomePage extends StatelessWidget {

  final TextEditingController _searchController = TextEditingController();


  ScrollController scrollController = ScrollController();

  void scrollControllerListener(){
    if(scrollController.offset>=scrollController.position.maxScrollExtent
    && !scrollController.position.outOfRange){

    }
  }

  @override

  Widget build(BuildContext context) {

    //List<Map<String,dynamic>> categories = categoryProvider.categories;
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    int crossAxisCount = (widthSize < 500) ? 2 :
    (widthSize < 960) ? 3 :
    (widthSize < 1280) ? 4 : 5;

    double childAspectRatio = (widthSize < 360) ? 0.62 :
    (widthSize < 430) ? 0.75:
    (widthSize < 500) ? 0.9:
    (widthSize < 550) ? 0.68:
    (widthSize < 650) ? 0.75:
    (widthSize < 800) ? 0.9:
    (widthSize < 960) ? 1.1:
    (widthSize < 1060) ? 1.0:
    (widthSize < 1200) ? 1.1:
    (widthSize < 1300) ? 1.2:1.3;
    String categoryId="0";
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Column(
            children: [
              appBar(),
              Center(child: SearchField(heightSize)),
              Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 40,
                      child: BlocConsumer<CategoryBloc,CategoryState>(
                        listener: (context,state){},
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
                                  },
                                );
                              }
                              ,
                            );
                          }
                          else return CircularProgressIndicator();

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
                                      index: index,)));
                                  },
                                  child: BlocBuilder<FavoriteBloc,FavoriteState>(
                                    builder: (context,state) {
                                      if(state is FavoriteLoadedState){
                                        return Item(
                                          id: product['id'],
                                          onPressed: (){
                                            context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product['id']));
                                          },
                                          image: Image.asset(product['picPath']),
                                          name: product['name'],
                                          price: product['price'],
                                          icon: state.favorites.contains(product['id'])
                                              ? SvgPicture.asset('assets/icons/hearted.svg')
                                              : SvgPicture.asset('assets/icons/unhearted.svg'),
                                        );
                                      }
                                      else return CircularProgressIndicator();
                                    }
                                  ),
                                );
                              },
                            );
                          }
                          else if(state is ProductLoadingState){
                            return CircularProgressIndicator();
                          }else if(state is ProductErrorState){
                            return ScaffoldMessenger(child: SnackBar(content: Text('there is an error fetching products')));
                          }
                          else return CircularProgressIndicator();
                        }
                      )

              ),

              Container(

                width: widthSize,
                height: 73,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: widthSize*0.22,
                      height: 73,
                      child: IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.home_filled)
                      ),
                    ),
                    Container(
                      width: widthSize*0.22,
                      height: 73,
                      child: IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage()));
                          },
                          icon: Icon(Icons.category)
                      ),
                    ),
                    Container(
                      width: widthSize*0.22,
                      height: 73,
                      child: IconButton(
                          onPressed: (){
                          },
                          icon: SvgPicture.asset("assets/icons/card.svg"),
                    ),
                    ),
                    Container(
                      width: widthSize*0.22,
                      height: 73,
                      child: IconButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              if(AuthRepository.isSignedIn){
                                return SafeArea(child: Scaffold(body: SignedInUser()));
                              }
                              else{
                                return Scaffold(body: SafeArea(child: SingleChildScrollView(child: SecondPage())));
                              }
                            }));
                          },
                          icon: Icon(Icons.person)
                      ),
                    )

                  ],
                ),
              )
            ],

          )),
      );
  }

  Container SearchField(double heightSize) {
    return Container(
                  margin: EdgeInsets.symmetric(vertical: heightSize*0.01),
                  child: InputField(
                    controller: _searchController,
                    inputType: TextInputType.name,
                    labelText: "",
                    prefixIcon: Icon(Icons.search,size: 34,),
                  ),

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
  final SvgPicture icon;
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
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
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


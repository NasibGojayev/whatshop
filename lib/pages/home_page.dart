import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/tools/custom_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import '../bloc_management/d_product_bloc/d_product_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_events.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../tools/colors.dart';

class HomePage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();


  HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      // Implement your refresh logic here
      CategoryState currentState = context.read<CategoryBloc>().state;
      String cId = '';
      if(currentState is CategoryLoaded){
        cId = currentState.categories[currentState.selectedIndex].id;
      }
      context.read<ProductBloc>().add(FetchByCategoryEvent(cId, forceRefresh: true));
    }
    return Scaffold(
      body: SafeArea(
        child: LiquidPullToRefresh(
          showChildOpacityTransition: false,
          height: 10,
          color: mainGreen,
          animSpeedFactor: 3,
          onRefresh: refresh,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Sliver App Bar - will collapse when scrolling down
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: SvgPicture.asset("assets/icons/logo.svg"),
                ),
                title: Text(
                  'WhatShop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1D1E20),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.04,
                    letterSpacing: -0.21,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: ProductSearchDelegate());
                    },
                    icon: Icon(Icons.search, size: 22),
                  )
                ],
                floating: true, // App bar will appear when scrolling up
                snap: true, // Snap effect when scrolling
                expandedHeight: 0, // No expanded height for this case
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => showSearch(context: context, delegate: ProductSearchDelegate()),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: bozumsu,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.search, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Ad və ya kodla axtarın',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: 0.45),
                                fontSize: 12, // Slightly larger for better readability
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              ),




              // Categories horizontal list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 40,
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          return ListView.builder(
                            itemCount: state.categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Category(
                                textColor: state.selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                                color: state.selectedIndex == index
                                    ? Color(0xFF25D366)
                                    : bozumsu,
                                name: state.categories[index].name,
                                onPressed: () {
                                  String categoryId = state.categories[index].id;
                                  context.read<CategoryBloc>().add(
                                      SetSelectedIndex(index));
                                  context.read<ProductBloc>().add(
                                      FetchByCategoryEvent(categoryId));
                                },
                              );
                            },
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),

              // Products grid
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadedState) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 350,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final product = state.products[index];
                          return GestureDetector(
                            onTap: () {
                              context.push('/product/${product.productId}');
                              /*GoRouter.of(context).push(
                                '/product/${product['product_id']}',
                              );*/
                            },
                            child: Item(
                              id: product.productId,
                              cartIcon: GestureDetector(onTap: (){
                                chooseOpts(context, product.productId);
                              }, child: Icon(Icons.shopping_cart_sharp)),
                              icon: GestureDetector(
                                onTap: (){
                                  context
                                      .read<FavoriteBloc>()
                                      .add(ToggleFavoriteEvent(favoriteObject: FavoriteObject(
                                    avgRating: product.avgRating,
                                      name: product.name,
                                      price: product.sizeOptions[0].price,
                                      image: product.images[0],
                                      productId: product.productId)));


                                },
                                child: BlocBuilder<FavoriteBloc, FavoriteStates>(
                                  builder: (context, state) {
                                    if (state is FavoriteLoadedState) {
                                      final updatedFavorites = state.favorites;
                                      final isFavorite = updatedFavorites.any((fav) => fav.productId == product.productId);
                                      //isFavorite?Icon(Icons.favorite,color: primaryColor, size: 24,):Icon(Icons.favorite_border_outlined,color: primaryColor, size: 24,);

                                      return Icon(isFavorite?Icons.favorite:Icons.favorite_border_outlined,color: primaryColor, size: 24,);

                                  }
                                    else {
                                      return Icon(Icons.favorite_border_outlined);
                                    }
                                  }
                                ),
                              ),

                              image: AnotherCarousel(
                                dotSize: 3,
                                indicatorBgPadding: 4,
                                showIndicator: true,
                                images:[
                                  for (var pic in product.images)
                                    Container(

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                        ),

                                        clipBehavior: Clip.hardEdge,

                                        child: Image.network(pic))
                                ],
                                autoplay: false,

                              ),
                              name: product.name,
                              price: product.sizeOptions[0].price,
                            ),
                          );
                        },
                        childCount: state.products.length,
                      ),
                    );
                  } else if (state is ProductLoadingState) {
                    return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ProductErrorState) {
                    return SliverToBoxAdapter(
                      child: Text('error occured \n${state.error}',style:TextStyle(
                        color: Colors.red,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,

                      ),)
                    );
                  } else if (state is EndOfProductsState) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text('Heleki mehsul yoxdur , gozlemede qalin ✨'),
                      ),
                    );
                  } else {
                    return SliverFillRemaining(
                      child: Center(child: Text('Gozlenilmeyen xeta bas verdi')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Your existing Item and Category widgets remain the same


class Item extends StatelessWidget {

  final Widget image;
  final String id;
  final String name;
  final num price;
  final Widget? icon;
  final Widget? cartIcon;
  const Item({
    super.key,
    required this.id,
    this.icon,
    required this.image,
    required this.name,
    required this.price, this.cartIcon,

  });



  @override
  Widget build(BuildContext context) {
    //double widthSize = MediaQuery.of(context).size.width;
    //double heightSize = MediaQuery.of(context).size.height;
    return Container(

      color: bozumsu, // Light grey background
      child: Stack(
        children: [

          Column(
            mainAxisSize: MainAxisSize.min, // Allow content to grow naturally
            children: [

              Container(
                width: 200,
                height: 220,

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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                  color: primaryColor,
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Positioned(
            top: 18,
            right: 18,

            child: Center(
              child: Container(
                  width: 35,
                  height: 35,
                  decoration: ShapeDecoration(
                    color:  Colors.white,
                    shape: OvalBorder(),
                  ),
                  child: Center(child: icon??Container())),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,

            child: Center(
              child: Container(
                  width: 35,
                  height: 35,
                  decoration: ShapeDecoration(
                    color:  Colors.white,
                    shape: OvalBorder(),
                  ),
                  child: Center(child: cartIcon??Container())),
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
      width: 130,
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

            fontSize: 11,
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


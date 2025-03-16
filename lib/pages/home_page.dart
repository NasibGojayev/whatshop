import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_cubit.dart';
import 'package:whatshop/bloc_management/product_bloc/product_event.dart';
import 'package:whatshop/tools/custom_search_delegate.dart';
import 'package:whatshop/tools/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_event.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import '../tools/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomePage extends StatelessWidget {

  final ScrollController scrollController = ScrollController();
  final SearchController searchController = SearchController();


  HomePage({super.key});

  void scrollControllerListener(){
    if(scrollController.offset>=scrollController.position.maxScrollExtent
    && !scrollController.position.outOfRange){

    }
  }



  @override

  Widget build(BuildContext context) {

    //double widthSize = getWidthSize(context);
    //double heightSize = getHeightSize(context);
    int crossAxisCount = getCrossAxisCount(context);
    double childAspectRatio = getChildAspectRatio(context);
    String categoryId = "0";
    Future<void> _refresh()async {
      await context.read<ProductBloc>()..add(FetchByCategoryEvent(categoryId,forceRefresh: true));
      print('now it refreshed');
    }
   /* Container(
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
            IconButton(onPressed: (){
              showSearch(context: context, delegate: ProductSearchDelegate());
            }, icon: Icon(Icons.search))
          ],
        ),
      ),
    )*/

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/icons/logo.svg" ),
        ),
        title: Text(
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
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: ProductSearchDelegate());
          }, icon: Icon(Icons.search,size: 28,))
        ],


      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: LiquidPullToRefresh(
            showChildOpacityTransition: true,
            height: 70,
            color: mainGreen,
            animSpeedFactor: 3,
            onRefresh: ()async{
              await _refresh();
            },
            child: Column(
              children: [
                SizedBox(height: 30,),

                Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 40,
                        child: BlocBuilder<CategoryBloc,CategoryState>(
                          builder: (context,state) {
                            if(state is CategoryLoaded){
                              return LiquidPullToRefresh(
                                onRefresh: ()async{

                                  await Future.delayed(Duration(seconds: 2));
                                },
                                child: ListView.builder(
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
                                ),
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
                                physics: AlwaysScrollableScrollPhysics(),
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
                                        product: product,)));
                                    },

                                    child:  Item(
                                            id: product['product_id'],
                                            onPressed: (){
                                              context.read<FavoriteCubit>().toggleFavorite(product);
                                            },
                                            image: CarouselSlider.builder(itemCount: product['pic_path'].length,
                                              itemBuilder: (BuildContext context, int index, int realIndex) {
                                                return Image.network(product['pic_path'][index],fit: BoxFit.fitWidth,width: 300,height: 500,);

                                              }, options: CarouselOptions(
                                                autoPlay: true


                                              ),),
                                            name: '${product['name']}',
                                            price: product['price'],
                                            icon: BlocBuilder<FavoriteCubit,List<Map<String,dynamic>>>(
                                                builder: (context,state){
                                                   return state.any((element) => element['product_id']==product['product_id'])
                                                        ? Icon(Icons.check_box,color: mainGreen,size: 30,)
                                                        : Icon(Icons.check_box_outline_blank,size: 30,);
                                                  }
                                                ),
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
              ],

            ),
          )),
      );
  }




  Container appBar(BuildContext context) {
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
                    IconButton(onPressed: (){
                      showSearch(context: context, delegate: ProductSearchDelegate());
                    }, icon: Icon(Icons.search))
                  ],
                ),
              ),
            );
  }
}

class Item extends StatelessWidget {

  final Widget image;
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



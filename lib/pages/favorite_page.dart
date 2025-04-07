import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:whatshop/deletable/favorite_bloc/favorite_state.dart';
import 'package:whatshop/pages/detailed_product_page.dart';
import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../bloc_management/favorite_bloc/favorite_events.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sevimli məhsullar ", style: TextStyle(
              color: Color(0xFF1D1E20),
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0.04,
            ),),

          ],
        ),
      ),
      body: Container(
        color: bozumsu,
        child: BlocBuilder<FavoriteBloc, FavoriteStates>(
          builder: (context, state) {
            context.read<FavoriteBloc>().initializeKeys();

            // Get the current product list from either state
            List<dynamic> products = [];
            if (state is FavoriteUpdatedState) {
              products = state.updatedFavorites;
            } else if (state is ShareLoadingState) {
              products = state.products; // Make sure your ShareLoadingState contains the products
            }

            return Stack(
              children: [
                // Main content (always visible)
                if (products.isNotEmpty)
                  ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return favorite_item(widthSize: widthSize, product: product);
                    },
                  )
                else
                  Center(child: Text('No favorite products', style: TextStyle(fontSize: 20))),

                      // Loading indicator overlay (only visible in ShareLoadingState)
                      if (state is ShareLoadingState)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: mainGreen,
                      )
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class favorite_item extends StatelessWidget {
  const favorite_item({
    super.key,
    required this.widthSize,
    required this.product,
  });

  final double widthSize;
  final dynamic product;


  @override
  Widget build(BuildContext context) {
    print(product['pic_path'][0]);
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        width: widthSize,
        height: 200,
        child: Row(
          children: [
            Container(
              width: 150,
              child: AnotherCarousel(
                dotSize: 3,
                  indicatorBgPadding: 4,
                  showIndicator: true,
                  images:[
                    for (var pic in product['pic_path'])
                      Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),

                          clipBehavior: Clip.hardEdge,

                          child: Image.network(pic))
                  ],
                autoplay: false,

              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      // Product Name
                      Expanded(
                        child: Text(
                          product['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),

                      // Options Icon (Three Dots)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String value) {
                          // Handle menu actions
                          if (value == 'share') {
                            // Share logic
                          } else if (value == 'remove') {
                            // Remove logic
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 'share',
                            child: Text('Paylaş'),
                          ),
                           PopupMenuItem(
                            onTap: (){
                              context.read<FavoriteBloc>().add(RemoveFavoriteEvent(product['product_id']));
                            },
                            value: 'remove',
                            child: Text('Sil'),
                          ),
                        ],
                      ),
                    ],
                  ),


                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('among 7401 people , it got 4.3 star'),
                      SizedBox(height: 20,),
                      Text('${product['price']} AZN',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),)
                    ],
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                            width: 50,
                            height: 40,
                            decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(child: Text('Al',style: TextStyle(
                              fontSize: 20
                            ),))),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                                color: mainGreen,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(child: Text('sebete at',style: TextStyle(
                                fontSize: 20
                            )))),
                      )
                    ],
                  ),
                  SizedBox(height: 10,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../bloc_management/favorite_bloc/favorite_events.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sevimli məhsullar ",
              style: TextStyle(
                color: Color(0xFF1D1E20),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0.04,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: bozumsu,
        child: BlocBuilder<FavoriteBloc, FavoriteStates>(
          builder: (context, state) {
            // Get the current product list from either state
            List<dynamic> products = [];
            if (state is FavoriteLoadedState) {
              products = state.favorites;
            }

            return products.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return FavoriteItem(
                          widthSize: widthSize, favoriteObject: product);
                    },
                  )
                : Center(
                    child: Text('No favorite products',
                        style: TextStyle(fontSize: 20)));
          },
        ),
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.widthSize,
    required this.favoriteObject,
  });

  final double widthSize;
  final FavoriteObject favoriteObject;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(
            motion: DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  context.read<FavoriteBloc>().add(RemoveFavoriteEvent(favoriteObject.productId));
                },
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Sil',
              )
            ]),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          onTap: (){
            context.push('/product/${favoriteObject.productId}');
          },
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
                SizedBox(width: 150, child: Image.network(favoriteObject.image)),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Product Name
                          Expanded(
                            child: Text(
                              favoriteObject.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
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
                              PopupMenuItem(
                                onTap: () {
                                  Share.share('https://whatshop.az/product/${favoriteObject.productId}');                                },
                                child: Text('Paylaş'),),

                              PopupMenuItem(
                                onTap: () {
                                  context.read<FavoriteBloc>().add(
                                      RemoveFavoriteEvent(
                                          favoriteObject.productId));
                                },
                                value: 'remove',
                                child: Text('Sil'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 130,

                            height: 30,
                            child: Row(
                              children: [
                                RatingBar(
                                  ignoreGestures: true,
                                  itemSize: 17,
                                  initialRating: favoriteObject.avgRating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star,color: primaryColor,),
                                    half: Icon(Icons.star_half,color: primaryColor,),
                                    empty: Icon(Icons.star_border,color: primaryColor,),
                                  ),
                                  onRatingUpdate: (_) {},
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  "${favoriteObject.avgRating}",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E1E1E),
                                  ),
                                ),
                                SizedBox(width: 5,)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${favoriteObject.price} AZN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      )),
                      GestureDetector(
                        onTap: () {
                          chooseOpts(context, favoriteObject.productId);
                        },
                        child: Container(

                            height: 28,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text('Səbətə At',
                                    style: TextStyle(
                                        fontSize: 15,
                                      color: Colors.white
                                    )))),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


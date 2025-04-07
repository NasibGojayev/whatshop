import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatshop/bloc_management/d_product_bloc/d_product_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_events.dart';
import '../bloc_management/cart_bloc/cart_bloc.dart';
import '../bloc_management/cart_bloc/cart_event.dart';
import '../bloc_management/d_product_bloc/d_product_event.dart';
import '../bloc_management/d_product_bloc/d_product_state.dart';
import '../bloc_management/favorite_bloc/favorite_bloc.dart';
import '../bloc_management/favorite_bloc/favorite_states.dart';
import '../tools/colors.dart';

class DetailedProductPage extends StatelessWidget {
  final String productId;
  const DetailedProductPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ProductIdBloc>(context).add(FetchProductIdEvent(productId));
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    late Product product;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Ətraflı',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  //context.read<FavoriteBloc>().add(CaptureProductsEvent());

                },
                icon: Icon(Icons.share)),
            SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  Share.share('https://whatshop.az/product/$productId');
                },
                icon: Icon(Icons.ios_share)),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        backgroundColor: bozumsu,
        body: SafeArea(
          child: BlocBuilder<ProductIdBloc, ProductIdState>(
              builder: (context, state) {
            if (state is ProductIdFetchedState) {
              product = state.product;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // appbar(widthSize: widthSize, heightSize: heightSize, product: product),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: bozumsu,
                                height: 400,
                                child: AnotherCarousel(
                                  images: [
                                    for (var i in product.images)
                                      InstaImageViewer(
                                        child:
                                            ClipRRect(child: Image.network(i)),
                                      )
                                  ],
                                  dotSize: 7,
                                  autoplay: false,
                                ),

                                //child: Image.network(product['pic_path'][0],),
                              )),
                          description(
                              widthSize: widthSize,
                              state: state,
                              heightSize: heightSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                  BottomButtons(
                      heightSize: heightSize,
                      widthSize: widthSize,
                      state: state)
                ],
              );
            } else if (state is ProductIdLoadingState) {
              return LinearProgressIndicator();
            } else if (state is ProductIdErrorState) {
              return Text(state.error);
            } else {
              return Text('unexpected error');
            }
          }),
        ));
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons(
      {super.key,
      required this.heightSize,
      required this.widthSize,
      required this.state
      });

  final double heightSize;
  final double widthSize;
  final ProductIdState state;

  @override
  Widget build(BuildContext context) {
    final stat = state as ProductIdFetchedState;
    final product = stat.product;

    return Container(
      decoration: BoxDecoration(

          border: Border(
        top: BorderSide(
          color: Colors.black12, // Sərhədin rəngi
          width: 2.0, // Sərhədin qalınlığı
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              width: widthSize * 0.20,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: BlocBuilder<FavoriteBloc, FavoriteStates>(
                  builder: (context, state) {
                if (state is FavoriteUpdatedState) {
                  return IconButton(
                      onPressed: () {
                        context
                            .read<FavoriteBloc>()
                            .add(ToggleFavoriteEvent(product: product));
                      },
                      icon: state.updatedFavorites.contains(product)
                          ? Icon(
                              Icons.favorite,
                              color: mainGreen,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: mainGreen,
                            ));
                } else {
                  return IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.error,
                        color: mainGreen,
                      ));
                }
              }),
            ),

          TextButton(
            onPressed: () {

              if(stat.colorOption.color == ''|| stat.sizeOption.size == '' ){

                chooseOpts(context, product.productId);
                return;
              }

              context.read<CartBloc>().add(
                  AddCartEvent(
                    product: product,
                    sizeOption: SizeOption(
                        price: stat.sizeOption.price,
                        size: stat.sizeOption.size,
                        isAvailable: true),
                    colorOption: ColorOption(
                        color: stat.colorOption.color,
                        isAvailable: true),));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Mehsul sebete elave olundu !'), // The message to display
                  duration: Duration(
                      milliseconds:
                          2300), // How long to show the snackbar (optional)
                  action: SnackBarAction(
                    // An optional action button
                    label: 'Sebete get',
                    onPressed: () {
                      context.go('/cart');
                    },
                  ),
                ),
              );
            },
            child: Container(
                width: widthSize * 0.7,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: mainGreen,
                ),
                child: Center(
                  child: Text(
                    'Sebete Elave et',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class description extends StatelessWidget {
  const description({
    super.key,

    required this.widthSize,
    required this.state,
    required this.heightSize,
  });

  final double widthSize;
  final ProductIdState state;
  final double heightSize;


  @override
  Widget build(BuildContext context) {
    final stat = state as ProductIdFetchedState;
    final Product product = stat.product;
    return Container(
      width: widthSize,
      color: bozumsu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Description',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x7F1E1E1E),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0.08,
                    letterSpacing: -0.32,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/whatsapp.png',
                      width: 70,
                    ),
                    Text(
                      '${stat.sizeOption.price} AZN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0.05,
                        letterSpacing: -0.32,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
          ),
          SizedBox(
            height: heightSize * 0.03,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: widthSize * 0.88,
              height: heightSize * 0.13,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Text(
                    product.description,
                    style: TextStyle(
                      color: Color(0xA51E1E1E),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Olcu Secin',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xCC1E1E1E),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.08,
                letterSpacing: -0.32,
              ),
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 20,
            children: [
              for (var i in product.sizeOptions)
                GestureDetector(
                  onTap: (){
                    context.read<ProductIdBloc>().add(SelectSizeEvent(size: i.size,price:i.price));
                  },
                  child: Container(
                      width: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(

                          color: stat.sizeOption.size == i.size?mainGreen:Colors.white,
                          border: Border.all(
                            color: stat.sizeOption.size == i.size?mainGreen:Colors.black,
                            width: 1,

                          )
                      ),
                      margin: EdgeInsets.only(left: 20),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                          child: Text(i.size,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: stat.sizeOption.size == i.size?Colors.white:Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      )),
                )
            ],
          ),
          SizedBox(
            height: 20,
          ),

          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text(
              'Reng Secin' ,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xCC1E1E1E),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0.08,
                letterSpacing: -0.32,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10,
            runSpacing: 20,
            children: [
              for (var i in product.colorOptions)
                GestureDetector(
                  onTap: (){
                    context.read<ProductIdBloc>().add(SelectColorEvent(color:i.color));
                  },
                  child: Container(
                    width: 100,
                      margin: EdgeInsets.only(left: 18),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(

                        color: stat.colorOption.color == i.color?mainGreen:Colors.white,
                        border: Border.all(
                          color: stat.colorOption.color == i.color?mainGreen:Colors.black,
                          width: 1,

                        )
                      ),

                      child: Center(
                        child: Container(

                          margin: EdgeInsets.symmetric(horizontal: 6,vertical: 5),

                          child: Text(i.color,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: stat.colorOption.color == i.color?Colors.white:Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      )),
                )
            ],
          ),
          SizedBox(
            height: 20,
          ),

          SizedBox(height: 10,)
        ],
      ),
    );
  }
}

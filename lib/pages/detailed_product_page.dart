import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_state.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop/pages/check_out_1.dart';
import '../bloc_management/cart_bloc/cart_bloc.dart';
import '../bloc_management/cart_bloc/cart_event.dart';
import '../tools/colors.dart';
import 'cart_page.dart';
class DetailedProductPage extends StatelessWidget {
  final int index;
  DetailedProductPage(
      {super.key,
      required this.index,
      });

  @override
  Widget build(BuildContext context) {


    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bozumsu,
        body: SafeArea(
      child: BlocBuilder<ProductBloc,ProductState>(
        builder: (context,state) {

           if(state is ProductLoadedState){
             final Map<String,dynamic> product = state.products[index];
             return Column(
               children: [
                 Expanded(
                   child: SingleChildScrollView(
                     child: Column(
                       children: [
                         appbar(widthSize: widthSize, heightSize: heightSize, product: product),
                         Align(
                           alignment: Alignment.center,
                           child: Container(
                             color: bozumsu,
                             width: widthSize * 0.7,
                             height: heightSize * 0.32,
                             child: Image.asset(product['picPath']),
                           ),
                         ),
                         description(widthSize: widthSize, product: product, heightSize: heightSize),
                       ],
                     ),
                   ),
                 ),
                 bottom_buttons(heightSize: heightSize, widthSize: widthSize,productId: product['id'],)

               ],
             );
           }
           else {
             return CircularProgressIndicator();
           }
        }
      ),
    ));
  }
}

class appbar extends StatelessWidget {
  const appbar({
    super.key,
    required this.widthSize,
    required this.heightSize,
    required this.product,
  });

  final double widthSize;
  final double heightSize;
  final Map<String, dynamic> product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(
                  left: widthSize * 0.02, top: heightSize * 0.01),
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: bozumsu,
                shape: OvalBorder(),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/icons/Frame.svg',
                ),
              )),
          Text(
            'Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.8),
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
          Container(
                      margin: EdgeInsets.only(
                          left: widthSize * 0.02, top: heightSize * 0.01),
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: bozumsu,
                        shape: OvalBorder(),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<FavoriteBloc>().add(ToggleFavoriteEvent(product['id']));

                        },
                        icon: BlocBuilder<FavoriteBloc,FavoriteState>(
                            builder: (context,state){
                              if(state is FavoriteLoadedState){
                                return state.favorites.contains(product['id'])
                                    ? SvgPicture.asset('assets/icons/hearted.svg')
                                    : SvgPicture.asset('assets/icons/unhearted.svg');
                              }
                              else if(state is NotLoggedInState){
                                return state.favorites.contains(product['id'])
                                    ? SvgPicture.asset('assets/icons/hearted.svg')
                                    : SvgPicture.asset('assets/icons/unhearted.svg');
                              }
                              else if(state is FavoriteLoadingState){
                                return CircularProgressIndicator();
                              }
                              else{
                                print((state as FavoriteErrorState).error);
                                return Text('error');
                              }
                            })
                      ))

        ],
      ),
    );
  }
}

class bottom_buttons extends StatelessWidget {
  const bottom_buttons({
    super.key,
    required this.heightSize,
    required this.widthSize,
    required this.productId
  });

  final double heightSize;
  final double widthSize;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: heightSize * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              context.read<CartBloc>().add(ToggleCartEvent(productId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Mehsul sebete elave olundu !'), // The message to display
                  duration: Duration(milliseconds: 3000), // How long to show the snackbar (optional)
                  action: SnackBarAction( // An optional action button
                    label: 'Sebete get',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));

                    },
                  ),
                ),
              );
            },
            child: Container(
              width: widthSize * 0.17,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 0.6)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset("assets/icons/card.svg"),
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOut1()));
            },
            child: Container(
                width: widthSize * 0.73,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF25D366),
                ),
                child: Center(
                  child: Text(
                    'Check Out',
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
    required this.product,
    required this.heightSize,
  });

  final double widthSize;
  final Map<String, dynamic> product;
  final double heightSize;

  @override
  Widget build(BuildContext context) {
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
                      '${product["price"]} AZN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 20,
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
          Padding(
            padding: EdgeInsets.only(left: widthSize * 0.1),
            child: Text(
              product["name"],
              style: TextStyle(
                color: Color(0xCC1E1E1E),
                fontSize: 28,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 0.03,
                letterSpacing: -0.32,
              ),
            ),
          ),
          SizedBox(
            height: heightSize * 0.03,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: widthSize * 0.88,
              height: heightSize * 0.13,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Text(
                    product['description'],
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
            height: heightSize * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Text(
              'Choose Size',
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
            height: heightSize * 0.03,
          ),
          Container(
            height: heightSize * 0.08,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product['sizes']?.length,
                itemBuilder: (context, index) {
                  return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: Color(0xFF25D366),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("${product['sizes']?[index]}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}

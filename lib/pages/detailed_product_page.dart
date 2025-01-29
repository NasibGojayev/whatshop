import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_bloc.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_event.dart';
import 'package:whatshop/bloc_management/favorite_bloc/favorite_state.dart';
import 'package:whatshop/bloc_management/product_bloc/product_bloc.dart';
import 'package:whatshop/bloc_management/product_bloc/product_state.dart';
import 'package:whatshop/pages/check_out_1.dart';
import '../deletable/product_provider.dart';
import '../tools/colors.dart';
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
        body: SafeArea(
      child: SingleChildScrollView(
        child: BlocBuilder<ProductBloc,ProductState>(
          builder: (context,state) {

             if(state is ProductLoadedState){
               final DocumentSnapshot product = state.products[index];
               return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
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
                             color: Colors.black.withValues(alpha: 0.800000011920929),
                             fontSize: 24,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w400,
                             height: 0,
                           ),
                         ),
                         BlocBuilder<FavoriteBloc,FavoriteState>(
                             builder: (context,state) {
                               if(state is FavoriteLoadedState){
                                 return Container(
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
                                       icon: state.favorites.contains(product['id'])
                                           ? SvgPicture.asset('assets/icons/hearted.svg')
                                           : SvgPicture.asset('assets/icons/unhearted.svg'),
                                     ));
                               }
                               else if(state is FavoriteErrorState){
                                 return Container(child: Text("an error occured",style: TextStyle(fontSize: 50),),);
                               }
                               else return CircularProgressIndicator();
                             }
                         ),
                       ],
                     ),
                   ),
                   Column(
                     children: [
                       Align(
                         alignment: Alignment.center,
                         child: Container(
                           width: widthSize * 0.7,
                           height: heightSize * 0.32,
                           child: Image.asset(product['picPath']),
                         ),
                       ),
                       Container(
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
                       ),
                       Container(
                         margin: EdgeInsets.only(top: heightSize * 0.03),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             Container(
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
                       )
                     ],
                   )
                 ],
               );
             }
             else return CircularProgressIndicator();
          }
        ),
      ),
    ));
  }
}

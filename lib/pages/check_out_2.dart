import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whatshop/main.dart';
import 'package:whatshop/pages/first_page.dart';
import 'package:whatshop/pages/home_page.dart';
import 'package:whatshop/Auth/sign_in.dart';

import '../provider_classes/user_details.dart';
import '../tools/colors.dart';

class CheckOut2 extends StatelessWidget {
  const CheckOut2({super.key});


  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
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
                    'Checkout (2/3)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.800000011920929),
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
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/icons/options.svg'),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Column(
                    children: [
                      SvgPicture.asset('assets/icons/completed.svg',width: 29,),
                      Text(
                        'Delivery Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1479FF),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 2.10,
                          letterSpacing: -0.32,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset('assets/icons/tre_xetleri.svg',width: widthSize*0.24,
                      colorFilter: ColorFilter.mode(Color(0xFF147AFF), BlendMode.srcIn),),
                  ),                  Column(
                    children: [
                      SvgPicture.asset('assets/icons/processing.svg',width: 35,),
                      Text(
                        'Payment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0x661E1E1E),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 2.10,
                          letterSpacing: -0.32,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SvgPicture.asset('assets/icons/tre_xetleri.svg',width: widthSize*0.24,),
                  ),
                  Column(
                    children: [
                      SvgPicture.asset('assets/icons/unCompleted.svg',width: 29,),
                      Text(
                        'Order Placed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0x661E1E1E),
                          fontSize: 10,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 2.10,
                          letterSpacing: -0.32,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                'Ödəniş metodunu seç',
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.31,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Column(
              children: [
                Center(
                  child: Container(
                    width: widthSize*0.8,
                    height: 60,
                    decoration: ShapeDecoration(
                        color: Color(0xFFEEEEEE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )
                    ),
                    child: TextButton(
                      onPressed: (){
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/add.svg'),
                          SizedBox(width: 10,),
                          Text(
                            'Odenis metodu elave et',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1479FF),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),


                Center(
                  child: Text(
                    'ODENIS METODU SEHIFESI KONSTRUKSIYA ALTINDADIR!!!',
                    style: TextStyle(
                      fontSize: 30
                    ),
                  ),
                ),
                SizedBox(height: 100,),
                Center(
                  child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNm6_q-xFNNKxFkyOhpv12PA2bN-xXaFS1ig&s'),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }
}


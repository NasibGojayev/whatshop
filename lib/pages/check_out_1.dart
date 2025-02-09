import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop/bloc_management/address_bloc/address_bloc.dart';
import 'package:whatshop/bloc_management/address_bloc/address_event.dart';
import 'package:whatshop/bloc_management/address_bloc/address_state.dart';

import '../tools/colors.dart';
import 'check_out_2.dart';

class CheckOut1 extends StatelessWidget {
  const CheckOut1({super.key});

  /*void _showAddAddressDialog(BuildContext context){
    TextEditingController addressLine1 = TextEditingController();
    TextEditingController addressLine2 = TextEditingController();
    TextEditingController nameSurname = TextEditingController();
    TextEditingController phone = TextEditingController();


    showCupertinoDialog(context: context, builder: (context){
      return CupertinoAlertDialog(
              title: Text("Adres elave et"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoTextField(
                    controller: addressLine1,
                    placeholder: 'Adres setiri 1',
                  ),
                  SizedBox(height: 10,),
                  CupertinoTextField(
                    controller: addressLine2,
                    placeholder: 'Adres setiri 2',
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (addressLine1.text.isNotEmpty) {
                      context.read<AddressBloc>().add(AddAddressEvent(addressLine1.text, addressLine2.text));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Elave et"),
                ),
              ],
            );


    });
  }*/

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAndMore(widthSize: widthSize, heightSize: heightSize),
           BlocBuilder<AddressBloc,AddressState>(
             builder: (context ,state ) {
               return Expanded(
                   child:  state is AddressLoadedState?ListView.builder(
                     itemCount: state.addresses.length,
                     itemBuilder: (context, index) {
                       final address = state.addresses[index];
                       return Container(
                         margin: EdgeInsets.only(bottom: 15),
                         clipBehavior: Clip.antiAlias,
                         decoration: ShapeDecoration(
                           color:  bozumsu,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                           ),
                         ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Column(
                               children: [
                                 Text(
                                   'Adres ${index + 1}',
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                     color: Color(0xFF1E1E1E),
                                     fontSize: 13,
                                     fontFamily: 'Inter',
                                     fontWeight: FontWeight.w400,
                                   ),
                                 ),
                               // ---
                                 SizedBox(height: 20,),
                               // ---
                                 Text(
                                   '${address['ad_soyad']}\n'
                                       '${address['line1']}\n'
                                       '${address['line2']}\n'
                                       '${state.addresses[index]['phone_num']}\n',
                                   style: TextStyle(
                                     color: Colors.black.withValues(
                                         alpha: 0.7),
                                     fontSize: 11,
                                     fontFamily: 'Inter',
                                     fontWeight: FontWeight.w400,
                                   ),
                                 ),
                               ],
                             ),
                             Column(
                               children: [
                                 TextButton(onPressed: (){
                                   context.read<AddressBloc>().add(DeleteAddressEvent(index));
                                 }, 
                                     child: Text('Adresi Sil',
                                     style: TextStyle(
                                       color: Colors.red,

                                     ),)),
                                 
                                 Container(
                                   height: heightSize * 0.14,
                                   width: widthSize * 0.3,
                                 
                                   child: Image.asset('assets/images/map.png'),
                                 ),
                               ],
                             )
                           ],
                         ),
                       );
                     },
                   ): state is AddressLoadingState?  Center(child: CircularProgressIndicator())
                       :state is NoAddressState? Center(
                     child: Text('Catdirilma adresi elave edin'),
                   ): Text("Addresses could not be loaded")

                               );
             }
           ),
           BlocBuilder<AddressBloc,AddressState>(
             builder: (context,state) {
               return Center(
                 child: TextButton(
                   onPressed: (){
                     if(state is AddressLoadedState && state.addresses.isNotEmpty){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOut2()));
                     }
                     else{
                       showCupertinoDialog(context: context,
                            builder: (BuildContext context){
                          return CupertinoAlertDialog(
                            title: Text('Xeta: Adress qeyd olunmayib'),
                            content: Text('Adressi qeyd etmek ucun "Yeni adres elave et" e tiklayin'),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: Text('Basa Dusdum'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                            ),
                          ],);
                            });}

                     }

                   ,
                   child: Container(
                     width: widthSize*0.8,
                     height: 70,
                     clipBehavior: Clip.antiAlias,
                     decoration: ShapeDecoration(
                       color: mainGreen,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(60),
                       ),
                     ),
                     child: Center(
                       child: Text(
                         'Odenise davam edin',
                         style: TextStyle(
                           color: Colors.white,
                           fontSize: 20,
                           fontFamily: 'Inter',
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ),
                   ),
                 ),
               );
             }
           ),
           SizedBox(height: 8,)


          ],
        ),
      ),
    );
  }
}







class HeaderAndMore extends StatelessWidget {
  const HeaderAndMore({
    super.key,
    required this.widthSize,
    required this.heightSize,
  });

  final double widthSize;
  final double heightSize;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                'Checkout (1/3)',
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
                  SvgPicture.asset('assets/icons/processing.svg',width: 29,),
                  Text(
                    'Catdirilma Unvani',
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
                child: SvgPicture.asset('assets/icons/tre_xetleri.svg',width: widthSize*0.2,),
              ),                  Column(
                children: [
                  SvgPicture.asset('assets/icons/unCompleted.svg',width: 29,),
                  Text(
                    'Odenis',
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
                child: SvgPicture.asset('assets/icons/tre_xetleri.svg',width: widthSize*0.2,),
              ),
              Column(
                children: [
                  SvgPicture.asset('assets/icons/unCompleted.svg',width: 29,),
                  Text(
                    'Tamamlandi',
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
            'Catdirilma adresi secin',
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
                context.read<AddressBloc>().add(ShowAddAddressDialog(context));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/add.svg'),
                  SizedBox(width: 10,),
                  Text(
                    'Yeni adres elave et',
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
        SizedBox(height: 16,),
      ],
    );
  }
}


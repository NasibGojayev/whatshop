import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider_classes/user_details.dart';
import '../tools/colors.dart';
import 'check_out_2.dart';

class CheckOut1 extends StatelessWidget {
  const CheckOut1({super.key});

  void _showAddAddressDialog(BuildContext context){
    TextEditingController addressLine1 = TextEditingController();
    TextEditingController addressLine2 = TextEditingController();
    TextEditingController nameSurname = TextEditingController();
    TextEditingController phone = TextEditingController();


    showCupertinoDialog(context: context, builder: (contex){
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
                // Add the address using the provider
                Provider.of<UserDetails>(context, listen: false)
                    .addAdress(addressLine1.text,addressLine2.text);

                Navigator.of(context).pop();
              }
            },
            child: Text("Elave et"),
          ),
        ],
      );
    });
  }

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
                    child: SvgPicture.asset('assets/icons/tre_xetleri.svg',width: widthSize*0.24,),
                  ),                  Column(
                    children: [
                      SvgPicture.asset('assets/icons/unCompleted.svg',width: 29,),
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
                'Select delivery address',
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
                    _showAddAddressDialog(context);
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
            Expanded(
                child: Consumer<UserDetails>(
                  builder: (context,provider,child){
                    if(provider.addresses.isEmpty){
                      return Center(
                        child: Text(
                          "No addresses added yet.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );

                    }
                    return ListView.builder(
                      itemCount: provider.addresses.length,
                      itemBuilder: (context, index) {
                       final adressProvider = Provider.of<UserDetails>(context);
                       final adress = adressProvider.addresses[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 15),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: Color(0xFFECECEC),
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
                                    'Adres ${index+1}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF1E1E1E),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
// ---
                                  Text(
                                    'Work',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10.56,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
// ---
                                  Text(
                                    'Ad Soyad\n'
                                        '${adress['line1']}\n'
                                        '${adress['line2']}\n'
                                        'Phone Number\n',
                                    style: TextStyle(
                                      color: Colors.black.withValues(alpha:0.699999988079071),
                                      fontSize: 11,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: heightSize*0.2,
                                width: widthSize*0.5,

                                child: Image.asset('assets/images/map.png'),
                              )
                            ],
                          ),
                        );
                        /*return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(provider.addresses[index]),
                          ),
                        );*/
                      },
                    );
                  },

                )
            ),
            Center(
              child: TextButton(
                onPressed: (){
                  if(Provider.of<UserDetails>(context,listen: false).addresses.isEmpty){
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
                         });

                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckOut2()));
                  }

                },
                child: Container(
                  width: widthSize*0.8,
                  height: 70,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Color(0xFF25D366),
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
            ),
            SizedBox(height: 8,)

          ],
        ),
      ),
    );
  }
}


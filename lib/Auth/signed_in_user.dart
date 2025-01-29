import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/sign_in.dart';
import 'package:whatshop/provider_classes/user_details.dart';

import '../pages/category_page.dart';
import '../pages/home_page.dart';

class SignedInUser extends StatelessWidget {
  const SignedInUser({super.key});
  @override
  Widget build(BuildContext context) {
    final userProvider= Provider.of<UserDetails>(context);
    final user= userProvider.user;
    userProvider.setUser();
    double widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
           Expanded(
             child: Column(
               children: [
                 Text('Ad Soyad : ${user?.name}',
                   style: TextStyle(
                       fontSize: 30
                   ),),
                 Text('Email: ${user?.email}',
                   style: TextStyle(
                       fontSize: 30
                   ),),
                 Text('Password : ${user?.password}',
                   style: TextStyle(
                       fontSize: 30
                   ),),
                 ElevatedButton(
                     onPressed: (){
                       AuthRepository.signOut();
                       Navigator.pop(context);
                     },
                     child: Text("sign out"))
               ],
             ),
           ),
            Container(

              width: widthSize,
              height: 73,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: widthSize*0.22,
                    height: 73,
                    child: IconButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        },
                        icon: Icon(Icons.home_filled)
                    ),
                  ),
                  Container(
                    width: widthSize*0.22,
                    height: 73,
                    child: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage()));
                        },
                        icon: Icon(Icons.category)
                    ),
                  ),
                  Container(
                    width: widthSize*0.22,
                    height: 73,
                    child: IconButton(
                      onPressed: (){
                      },
                      icon: SvgPicture.asset("assets/icons/card.svg"),
                    ),
                  ),
                  Container(
                    width: widthSize*0.22,
                    height: 73,
                    child: IconButton(
                        onPressed: (){

                        },
                        icon: Icon(Icons.person)
                    ),
                  )

                ],
              ),
            )

          ],

        ),
      ),
    );
  }
}

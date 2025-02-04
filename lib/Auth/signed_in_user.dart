import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/bloc_management/user_bloc/user_state.dart';
import '../bloc_management/user_bloc/user_bloc.dart';
import '../pages/cart_page.dart';
import '../pages/category_page.dart';
import '../pages/home_page.dart';

class SignedInUser extends StatelessWidget {
  const SignedInUser({super.key});

  @override

  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Istifadeci melumatlari"),
        centerTitle: true,
      ),
      body: Center(
        child: BlocBuilder<UserBloc,UserState>(
          builder: (context,state) {
            if(state is UserLoading){
              return LinearProgressIndicator();
            }
            else if(state is UserLoaded){
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Ad Soyad : ${state.user.displayName}',
                          style: TextStyle(
                              fontSize: 30
                          ),),
                        Text('Email: ${state.user.email}',
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));

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

              );
            }
            else{
              return Center(child: Text('İstifadeci melumatlari yuklene bilmedi\n Cixis edib yeniden daxil olun !',
              style: TextStyle(fontSize: 30,color: Colors.red),));

            }
          }
        ),
      ),
    );
  }
}

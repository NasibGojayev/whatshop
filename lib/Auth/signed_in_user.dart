import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/sign_in.dart';
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
                    child: BottomPanel(widthSize: widthSize),
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
class BottomPanel extends StatelessWidget {
  final double widthSize;
  const BottomPanel({super.key, required this.widthSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthSize,
      height: 73,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomIcon(context, Icons.home_filled, () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()))),
          _buildBottomIcon(context, Icons.category, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryPage()))),
          _buildBottomIcon(context, Icons.shopping_cart, ()=>Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()))),
          _buildBottomIcon(context, Icons.person, () {}),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: widthSize * 0.22,
      height: 73,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
      ),



    );
  }
}
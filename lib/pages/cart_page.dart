import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_bloc.dart';
import 'package:whatshop/bloc_management/cart_bloc/cart_state.dart';

import '../Auth/auth_repository.dart';
import '../Auth/sign_in.dart';
import '../Auth/signed_in_user.dart';
import '../tools/variables.dart';
import 'category_page.dart';
import 'home_page.dart';


class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = getWidthSize(context);
    //double heightSize = getHeightSize(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sebet"),

      ),
      body: SafeArea
        (child: Center(
          child: Column(
          children: [
            Expanded(
                child: BlocBuilder<CartBloc,CartState>(
                  builder: (context,state) {
                    if(state is CartLoadedState){
                      return ListView.builder(
                        itemBuilder: (context,index){
                          return ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text("${state.cart[index]} bu mehsul"),
                          );
                        },
                        itemCount: state.cart.length,
                      );
                    }
                    else if(state is CartLoadingState){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else if(state is CartErrorState){
                      return Center(child: Text(state.error),);

                    }
                    else if(state is NotLoggedInState){
                      return ListView.separated(
                        separatorBuilder: (context,index)=>SizedBox(height: 30,),
                          itemBuilder: (context,index){
                            return ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text("${state.cart[index]} bu mehsul"),
                              tileColor: Colors.red,



                            );
                          },
                        itemCount: state.cart.length,);
                    }
                    return Center(
                      child: Center(
                        child: Text("Xeta bas verdi"),
                      ),
                    );
                  }
                )
            ),
            bottom_panel(widthSize: widthSize)
          ],
                ),
        )),
    );
  }
}

class bottom_panel extends StatelessWidget {
  const bottom_panel({
    super.key,
    required this.widthSize,
  });

  final double widthSize;

  @override
  Widget build(BuildContext context) {
    return Container(
    
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    
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
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    if(AuthRepository.isSignedIn){
                      return SafeArea(child: Scaffold(body: SignedInUser()));
                    }
                    else{
                      return Scaffold(body: SafeArea(child: SingleChildScrollView(child: SecondPage())));
                    }
                  }));
                },
                icon: Icon(Icons.person)
            ),
          )
    
        ],
      ),
    );
  }
}

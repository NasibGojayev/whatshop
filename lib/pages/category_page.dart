import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/pages/home_page.dart';
import 'package:whatshop/tools/colors.dart';

import '../Auth/sign_in.dart';
import '../Auth/signed_in_user.dart';
import 'cart_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: widthSize*0.9,
                  color: Colors.white,
                  child: BlocConsumer<CategoryBloc,CategoryState>(
                    listener: (context,state){},
                    builder: (context,state) {
                      if(state is CategoryLoaded){
                        return ListView.builder(
                            itemBuilder: (context,index){
                              return Container(
                                margin: EdgeInsets.only(bottom: 20),
                                color: bozumsu,
                                child: ListTile(
                                  leading: Image.asset("${state.categories[index]['iconPath']}"),
                                  subtitle: Text("${state.categories[index]['description']}"),
                                  title: Text(
                                      '${state.categories[index]["name"]}'
                                  ),
                                ),
                              );
                            },itemCount: state.categories.length);
                      }
                      else if(state is CategoryError){
                        return ScaffoldMessenger(child: SnackBar(content: Text('An error occured while fetching categories')));
                      }
                      else return CircularProgressIndicator();
                    }
                  ),
                ),
              ),
              Container(

                width: widthSize,
                height: 73,
                child: BottomPanel(widthSize: widthSize),
              )
            ],
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
          _buildBottomIcon(context, Icons.category, (){}),
          _buildBottomIcon(context, Icons.shopping_cart, () =>Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()))),
          _buildBottomIcon(context, Icons.person, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AuthRepository.isSignedIn
                    ? const SafeArea(child: Scaffold(body: SignedInUser()))
                    : Scaffold(body: SafeArea(child: SingleChildScrollView(child: SecondPage()))),
              ),
            );
          }),
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
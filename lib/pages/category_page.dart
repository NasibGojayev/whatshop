import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
                          onPressed: (){},
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
              )
            ],
          ),

      ),
    );
  }
}

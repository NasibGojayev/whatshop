import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/tools/colors.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    //double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Kateqoriyalar'),
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
            ],
          ),

      ),
    );
  }
}

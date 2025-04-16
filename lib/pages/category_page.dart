import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_bloc.dart';
import 'package:whatshop/bloc_management/category_bloc/category_state.dart';
import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Kateqoriyalar'),
      ),
      body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: getWidthSize(context)*0.9,
                    color: Colors.white,
                    child: BlocConsumer<CategoryBloc,CategoryState>(
                      listener: (context,state){},
                      builder: (context,state) {

                        if(state is CategoryLoaded){
                          return RefreshIndicator(
                            onRefresh: ()async{

                              await Future.delayed(Duration(seconds: 1));
                            },
                            child: ListView.builder(
                                itemBuilder: (context,index){

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    color: bozumsu,
                                    child: ListTile(
                                      leading: Image.network(state.categories[index].image),
                                      subtitle: Text(state.categories[index].description),
                                      title: Text(
                                          state.categories[index].name
                                      ),
                                    ),
                                  );
                                },itemCount: state.categories.length),
                          );
                        }
                        else if(state is CategoryError){
                          return ScaffoldMessenger(child: SnackBar(content: Text('An error occured while fetching categories')));
                        }
                        else {
                          return CircularProgressIndicator();
                        }
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),

      ),
    );
  }
}

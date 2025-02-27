import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatshop/Auth/auth_service.dart';
import 'package:whatshop/pages/sign_in.dart';
import 'package:whatshop/bloc_management/user_bloc/user_state.dart';
import '../bloc_management/user_bloc/user_bloc.dart';
import '../bloc_management/user_bloc/user_event.dart';


class SignedInUser extends StatelessWidget {
  const SignedInUser({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("İstifadəçi məlumatları"),
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
                        Text('Created at : ${state.user.createdAt}',
                          style: TextStyle(
                              fontSize: 30
                          ),),
                        Text('Email: ${state.user.email}',
                          style: TextStyle(
                              fontSize: 30
                          ),),

                        ElevatedButton(
                            onPressed: (){
                              AuthService().signOut();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
                            },
                            child: Text("sign out"))
                      ],
                    ),
                  )

                ],

              );
            }
            else{
              return Center(child: Column(
                children: [
                  Text('İstifadeci melumatlari yuklene bilmedi\n Cixis edib yeniden daxil olun !',
                  style: TextStyle(fontSize: 30,color: Colors.red),),
                  ElevatedButton(
                      onPressed: () {
                        AuthService().signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
                      },
                    child: Text(
                      'cixis edin!',
                    style: TextStyle(fontSize: 30,color: Colors.black),),),

                  ElevatedButton(
                    onPressed: () {
                     context.read<UserBloc>().add(FetchUserEvent());
                    },
                    child: Text(
                      'Fetch again!',
                      style: TextStyle(fontSize: 60,color: Colors.green),),)


                ],
              ));

            }
          }
        ),
      ),
    );
  }
}

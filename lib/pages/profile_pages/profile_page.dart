import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whatshop/Auth/auth_service.dart';
import 'package:whatshop/pages/profile_pages/sign_in.dart';
import 'package:whatshop/bloc_management/user_bloc/user_state.dart';
import 'package:whatshop/tools/colors.dart';
import '../../bloc_management/user_bloc/user_bloc.dart';
import '../../bloc_management/user_bloc/user_event.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    SupabaseClient supabaseClient = Supabase.instance.client;
    User? user = supabaseClient.auth.currentUser;
    return Scaffold(
      backgroundColor: bozumsu,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(

                          radius: 30,
                          child: Text(
                            '${user!.userMetadata?['fullname'][0]}',

                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user.userMetadata!['fullname']}",
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${user.email}",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 40,
                      height: 40,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.notifications,
                            color: primaryColor,
                          )))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 96,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: primaryColor,
                          size: 40,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Əvvəl',
                          style: TextStyle(
                              fontSize: 15,
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Baxdiqlarim',
                          style: TextStyle(
                              fontSize: 15,
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/package.webp',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Sifarislerim',
                          style: TextStyle(
                              fontSize: 15,
                              color: primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ProfTile(
                leading: Icon(Icons.person),
                title: 'İstifadəçi Məlumatları',
                onTap: () {
                  context.push('/user_details');
                }),
            SizedBox(
              height: 10,
            ),
            ProfTile(
                leading: Icon(Icons.business_center_outlined),
                title: 'WhatShop Haqqında',
                onTap: () {
                  context.push('/about');
                }),
            SizedBox(
              height: 10,
            ),
            ProfTile(
                leading: Icon(Icons.phone),
                title: 'Bizimlə Əlaqə',
                onTap: () {
                  context.push('/contact_us');
                }),
            SizedBox(
              height: 10,
            ),
            ProfTile(
                leading: Icon(Icons.help),
                title: 'Dəstək Xidməti',
                onTap: () {
                  context.push('/support');
                }),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class previous extends StatelessWidget {
  const previous({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserLoading) {
        return LinearProgressIndicator();
      } else if (state is UserLoaded) {
        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Created at : ${state.user.createdAt}',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Email: ${state.user.email}',
                    style: TextStyle(fontSize: 30),
                  ),
                  ElevatedButton(
                    onPressed: () => signOut(context),
                    child: const Text("Sign Out"),
                  )
                ],
              ),
            )
          ],
        );
      } else {
        return Center(
            child: Column(
          children: [
            Text(
              'İstifadeci melumatlari yuklene bilmedi\n Cixis edib yeniden daxil olun !',
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
              child: Text(
                'cixis edin!',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserBloc>().add(FetchUserEvent());
              },
              child: Text(
                'Fetch again!',
                style: TextStyle(fontSize: 60, color: Colors.green),
              ),
            ),
          ],
        ));
      }
    });
  }
}

class ProfTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final VoidCallback onTap;
  const ProfTile({super.key, required this.title, required this.onTap, required this.leading});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        minTileHeight: 60,
        tileColor: Colors.white,
        leading: leading,
        title: Text(title),
        trailing: GestureDetector(
            onTap: () => onTap, child: Icon(Icons.arrow_forward_ios)),
      ),
    );
  }
}

void signOut(BuildContext context) async {
  try {
    // Show loading indicator
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Signing out...'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Perform sign-out
    await AuthService().signOut();

    // Navigate after successful sign-out
    if (context.mounted) {
      // Clear navigation stack completely
      GoRouter.of(context).go('/sign_in');

      // Alternative: If you want to replace entire navigation history
      // GoRouter.of(context).go('/first_page', extra: {'clearStack': true});
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/tools/colors.dart';

class ErrorPage extends StatelessWidget {
  final String path;
  const ErrorPage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bozumsu,
      appBar: AppBar(
        title: const Text('Mövcud olmayan səhifə'),

      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                width: 100,
                child: Image.asset('assets/images/sad.png')),
            SizedBox(height: 120,),

            Center(
              child: Text('Axtardığınız səhifə və ya məhsul tapılmadı ..',style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 20
              ),),
            ),
            Text(path),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              context.go('/');
            }, child: Text('Əsas Səhifəyə qayıt',style: TextStyle(
              fontSize: 20
            ),))
          ],
        ),
      )
    );
  }
}

import 'package:flutter/material.dart';
import 'profile_pages/sign_in.dart';
import '../tools/colors.dart';
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Center(child: image(context)),
                  textWritten(context),
                ],
              ),
            ),


            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: GetStarted(clicked: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
              },
              width: MediaQuery.of(context).size.width*0.87,
              height: 70),


              ),


          ],
        ),
      ),
    );
  }










  Column textWritten(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          'Ən yaxşı',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 36,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
    // ---
        Text(
          'tərzini tap',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 36,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
    // ---
        Container(
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width*0.6,
          child: Text(
            'Join and discover the best style according to your passion',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0x99323232),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ),
        )
      ],
    );
  }

  Container image(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.55,
      margin: EdgeInsets.symmetric(vertical:  MediaQuery.of(context).size.height*0.02),
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
    Radius.circular(33),
    ),
    ),),
      child: Image.network('https://storage.googleapis.com/whatshop_bucket/frame2.png'),

        );
  }
}


class GetStarted extends StatelessWidget {
  final VoidCallback clicked;
  final String insideText;
  final double width ;
  final double height;
  const GetStarted({
    super.key,
    required this.clicked ,
    required this.width,
    required this.height,
    this.insideText = "Get Started"
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clicked,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 14.50),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: mainGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              insideText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

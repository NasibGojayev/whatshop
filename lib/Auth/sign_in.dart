import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/pages/first_page.dart';
import 'package:whatshop/pages/home_page.dart';
import 'package:whatshop/Auth/sign_up.dart';
import 'package:whatshop/deletable/product_provider.dart';
import 'package:whatshop/tools/colors.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return
       Scaffold(
        body: SafeArea(child: SingleChildScrollView(child: SecondPage())),
    );
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});


  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHidden = false;
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Container(

      child: Column(

        children: [
          imgButton(widthSize, heightSize, context),
          Container(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      'Xosh Gelmisiniz',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 22,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    SizedBox(height: heightSize * 0.005,),
                    Text(
                      'Hesabiniza giris edin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x7F1E1E1E),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: heightSize * 0.03,),
              InputField(prefixIcon: Icon(Icons.email), labelText: "Email", inputType: TextInputType.emailAddress,controller: _emailController,),
              SizedBox(height: heightSize * 0.015,),
              Stack(
                  children:[
                    InputField(prefixIcon: Icon(Icons.lock), labelText: "Sifre", inputType: TextInputType.visiblePassword , hidden: !isHidden,
                    controller: _passwordController,),
                    Positioned(
                        top: heightSize*0.005,
                        right: 10 ,
                        child: IconButton(
                            onPressed: (){
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: isHidden?Icon(Icons.visibility):Icon(Icons.visibility_off))
                    )]
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            setState(() {
                              remember  = !remember;
                            });
                          },
                          icon: remember?Icon(Icons.check_circle):Icon(Icons.radio_button_unchecked) ,color: Colors.green,),
                        Text(
                          'Yadda saxla',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF1479FF),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    Text(
                      'Sifreni Unutmusunuz?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFF1418),
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        height: 0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
          //SizedBox(height: heightSize*0.001,),
          SignInBottom(widthSize, heightSize)


        ],
      ),
    );
  }

  Container SignInBottom(double widthSize, double heightSize) {
    return Container(
          child: Column(
            children: [
              Container(
                width: widthSize*0.6,
                child: Row(
                  children: [
                    Container(
                      width: 73,
                      height: 73,
                      decoration: BoxDecoration(
                        image: DecorationImage(

                          image: AssetImage('assets/images/whatsapp.png', ),
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(

                          image: AssetImage('assets/images/google.png', ),
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        image: DecorationImage(

                          image: AssetImage('assets/images/facebook.png', ),
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),

                  ],
                ),
              ),
             GetStarted(clicked: ()async{
               String email = _emailController.text.trim();
               String password = _passwordController.text.trim();
               await AuthRepository.signIn(email, password);
               if(AuthRepository.isSignedIn){

                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   Provider.of<ProductProvider>(context).fetchFavorites();
                   return HomePage();
                 }));
               }
               else{
                 showCupertinoDialog(context: context, builder: (context){
                   return CupertinoAlertDialog(
                       title: Text('Email ve ya sifre yanlisdir'),
                       actions: [
                         CupertinoDialogAction(
                             isDestructiveAction: true,
                             onPressed: (){
                               Navigator.of(context).pop();
                             },
                             child: Text('oldu')

                         )
                       ]
                   );
                 });
               }


             }, width: widthSize*0.9, height: heightSize*0.08,insideText: "Giris edin",),

              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hesabiniz yoxdur?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x991E1E1E),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    SizedBox(width: 10,),
                    TextButton(
                      onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                      },
                      child: Text(
                        'Qeydiyyatdan kecin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1479FF),
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
  }
}

class InputField extends StatelessWidget {
  final Icon prefixIcon;
  final String labelText;
  final TextInputType inputType;
  final bool hidden;
  final TextEditingController controller;

   InputField({
    super.key ,
    required this.prefixIcon ,
    required this.labelText ,
    required this.inputType,
    this.hidden = false,
     required this.controller


  });

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;

    return Container(

      width: widthSize*0.89,
      height: heightSize*0.06,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: bozumsu,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),

      ),

      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: CupertinoTextField(
          decoration: BoxDecoration(
            color: bozumsu
          ),
          controller: controller,
          placeholder: '$labelText',
          prefix: prefixIcon,
          style: TextStyle(

            fontSize: 22
          ),
          obscureText: hidden,
          keyboardType: inputType,
          // Use number input if needed

        ),
      ),
    );
  }
}



Stack imgButton(double widthSize, double heightSize, BuildContext context) {
    return Stack(
          children:[
            Container(
              width: widthSize*0.97,
              height: heightSize*0.37,
              child: Image.asset('assets/images/frame 2.1.png'),
            ),
            Container(
              margin: EdgeInsets.only(left: widthSize*0.02 , top: heightSize*0.01),
                width: 48,
                height: 48,
                decoration: ShapeDecoration(
                  color: bozumsu,
                  shape: OvalBorder(),
                ),
                child: IconButton(onPressed: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstPage()));
                  Navigator.pop(context);
                }, icon: SvgPicture.asset('assets/icons/Frame.svg',),
                )
            ),
          ]
        );
  }










/**/
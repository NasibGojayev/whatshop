import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatshop/Auth/auth_repository.dart';
import 'package:whatshop/Auth/sign_in.dart';
import 'package:whatshop/pages/home_page.dart';

import '../pages/first_page.dart';
import '../tools/colors.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: ThirdPage(),
      )),
    );
  }
}

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool isLogin = false;
  bool isHidden = false;
  bool remember = true;
  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Column(
      children: [
        igmButton(widthSize, heightSize, context),
        Container(
          child: Column(
            children: [
              Text(
                'Qeydiyyatdan Kecin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF1E1E1E),
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              SizedBox(
                height: heightSize * 0.005,
              ),
              Text(
                'Yeni Hesab Yaradin',
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
        SizedBox(
          height: heightSize * 0.03,
        ),
        InputField(
          controller: _nameController,
            prefixIcon: Icon(Icons.person),
            labelText: "Ad Soyad",
            inputType: TextInputType.name),
        SizedBox(
          height: heightSize * 0.015,
        ),
        InputField(
          controller: _emailController,
            prefixIcon: Icon(Icons.email),
            labelText: "E-Mail",
            inputType: TextInputType.emailAddress),
        SizedBox(
          height: heightSize * 0.015,
        ),
        Stack(children: [
          InputField(
            controller: _passwordController,
            prefixIcon: Icon(Icons.lock),
            labelText: "Sifre",
            inputType: TextInputType.visiblePassword,
            hidden: !isHidden,
          ),
          Positioned(
              top: heightSize * 0.005,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  icon: isHidden
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off)))
        ]),
        SizedBox(height: heightSize*0.02,),

        Container(
          child: Column(
            children: [
              Container(
                width: widthSize * 0.6,
                child: Row(
                  children: [
                    Container(
                      width: 73,
                      height: 73,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/whatsapp.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: AuthRepository.signInWithGoogle,
                      child: Container(
                        margin: EdgeInsets.only(right: 14),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/google.png',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/facebook.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: heightSize*0.02,),
              GetStarted(
                clicked: () async{
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  String name = _nameController.text.trim();
                   await AuthRepository.signUp(email,password,name);
                 if(AuthRepository.isSignedUp){
                   Navigator.pushReplacement(context,
                       MaterialPageRoute(builder: (context) => WelcomePage()));
                 }
                 else{
                   showCupertinoDialog(context: context, builder: (context){
                     return CupertinoAlertDialog(
                       title: Text('Qeydiyyat xetasi bas verdi'),
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
                },
                width: widthSize * 0.9,
                height: heightSize * 0.08,
                insideText: "Qeydiyyati Tamamlayin",
              ),
            ],
          ),
        )
      ],
    );
  }

  Stack igmButton(double widthSize, double heightSize, BuildContext context) {
    return Stack(children: [
      Container(
        width: widthSize * 0.97,
        height: heightSize * 0.37,
        child: Image.asset('assets/images/frame 2.2.png'),
      ),
      Container(
          margin:
              EdgeInsets.only(left: widthSize * 0.02, top: heightSize * 0.01),
          width: 50,
          height: 50,
          decoration: ShapeDecoration(
            color: bozumsu,
            shape: OvalBorder(),
          ),
          child: IconButton(
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstPage()));
              Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/Frame.svg',
            ),
          )),
    ]);
  }
}
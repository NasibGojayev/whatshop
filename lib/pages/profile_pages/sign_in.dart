import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:whatshop/Auth/auth_service.dart';

import 'package:whatshop/tools/colors.dart';
import 'package:whatshop/tools/variables.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isHidden = false;
  bool remember = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go('/first_page');
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
          child: Container(
            width: getWidthSize(context),
            height: getHeightSize(context),
            color: bozumsu,
            child: Column(
              children: [
                SizedBox(
                    height: 250, child: Image.asset('assets/images/greenGirl.png')),
                Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Xoş Gəlmisiniz',
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
                          height: 10,
                        ),
                        Text(
                          'Hesabınıza giriş edin',
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
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                      InputField(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: isHidden
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Şifrə",
                        inputType: TextInputType.visiblePassword,
                        hidden: !isHidden,
                        controller: passwordController,
                      ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {

                                },
                                icon: remember
                                    ? Icon(Icons.check_circle)
                                    : Icon(Icons.radio_button_unchecked),
                                color: Colors.green,
                              ),
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
                            'Şifrəni Unutmusunuz?',
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
                GestureDetector(
                  onTap: ()  async{
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();
                    try {

                      final auth = AuthService();
                      await auth.signInWithEmailAndPassword(email, password);

                      if (context.mounted) {
                        GoRouter.of(context).pushReplacement('/');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                  title: Text('Email və ya şifrə yanlışdır'),
                                  actions: [
                                    CupertinoDialogAction(
                                        isDestructiveAction: true,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('oldu'))
                                  ]);
                            });
                      }
                    }
                  },

                  child: Container(
                    width: getWidthSize(context) * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: mainGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                          'Daxil Ol',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                ),
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text(
                      'Hesabınız Yoxdur?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x991E1E1E),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        GoRouter.of(context).push('/sign_up');
                      },
                      child: Text(
                        'Qeydiyyatdan Keçin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1479FF),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    )
    );
  }
}

class InputField extends StatelessWidget {
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final String labelText;
  final TextInputType inputType;
  final bool hidden;
  final TextEditingController controller;

  const InputField(
      {super.key,
      required this.prefixIcon,
      required this.labelText,
      required this.inputType,
      this.hidden = false,
      required this.controller,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: getWidthSize(context) * 0.89,
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
          suffix: suffixIcon,
          decoration: BoxDecoration(color: bozumsu),
          controller: controller,
          placeholder: labelText,
          prefix: prefixIcon,
          style: TextStyle(fontSize: 22),
          obscureText: hidden,
          keyboardType: inputType,
          // Use number input if needed
        ),
      ),
    );
  }
}

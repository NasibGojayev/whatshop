
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:whatshop/Auth/auth_service.dart';
import 'package:whatshop/pages/profile_pages/sign_in.dart';
import 'package:whatshop/tools/variables.dart';
import '../../tools/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isHidden = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              if(Navigator.canPop(context)){
                GoRouter.of(context).pop();
              }
              else{
                context.push('/first_page');
              }
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/frame 2.2.png'),
            Column(
              children: [
                Text(
                  'Qeydiyyat',
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
                  height:0,
                ),
                Text(
                  'Yeni Hesab Yaradın',
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
              height: 15,
            ),
            InputField(
                controller: nameController,
                prefixIcon: Icon(Icons.person),
                labelText: "Ad Soyad",
                inputType: TextInputType.name),
            SizedBox(
              height: 20,
            ),
            InputField(
                controller: emailController,
                prefixIcon: Icon(Icons.email),
                labelText: "E-Mail",
                inputType: TextInputType.emailAddress),
            SizedBox(
              height: 20,
            ),

            PasswordField(
              passwordController: passwordController,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async{
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                String name = nameController.text.trim();
                if (email.isEmpty || password.isEmpty || name.isEmpty) {
                  showCupertinoDialog(context: context, builder: (context){
                    return CupertinoAlertDialog(
                        title: Text('E-Mail , şifrə və ya ad soyad boş ola bilməz'),
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
                  return;
                }
                try {

                  AuthService auth = AuthService();
                  await auth.signUpWithEmailAndPassword(
                    email: email,
                    password: password,
                    name: name,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Qeydiyyat tamamlandı!, Artıq giriş edə bilərsiniz..'), // The message to display
                        duration: Duration(
                            milliseconds:
                            2300), // How long to show the snackbar (optional)
                      ),
                    );
                    context.go('/'); // Using GoRouter
                  }
                } catch (e) {
                  if (context.mounted) {
                    showCupertinoDialog(context: context, builder: (context){
                      return CupertinoAlertDialog(
                          title: Text('Qeydiyyatda problem oldu'),
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
                    'Qeydiyyatdan Keç',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              )
            )
          ],
        )
      )),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  const PasswordField({super.key, required this.passwordController});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = widget.passwordController;
    return InputField(
      suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isHidden = !isHidden;
            });
          },
          icon: isHidden
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off)),
      controller: passwordController,
      prefixIcon: Icon(Icons.lock),
      labelText: "Şifrə",
      inputType: TextInputType.visiblePassword,
      hidden: !isHidden,
    );
  }
}

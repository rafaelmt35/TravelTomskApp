// ignore_for_file: unused_field, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/homepage.dart';
import 'package:travel_app/signin_service/signin.dart';
import 'package:travel_app/widgets/custom_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'googlesignin.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  bool visibleAlert = false;

  @override
  Widget build(BuildContext context) {
    Future SignUp() async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text.trim());
      } on FirebaseAuthException catch (e) {
        print(e);
      }
      // navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage(
                    signInWithoutGoogle: false,
                  )));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              color: maincolor,
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Icon(
                          Icons.travel_explore,
                          size: 75,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textFieldandCommand(
                          emailcontroller,
                          'Адрес электронной почты',
                          'Введите адрес электронной почты'),
                      textFieldandCommand(
                          usernamecontroller, 'Имя', 'Введите имя'),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Пароль',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      PasswordTextField(
                          passwordcontroller: passwordcontroller,
                          command: 'Пароль'),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 220,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: maincolor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () async {
                              await SignUp();
                              FirebaseFirestore.instance
                                  .collection('Account')
                                  .add({
                                'email': emailcontroller.text,
                                'uid': FirebaseAuth.instance.currentUser?.uid,
                                'username': usernamecontroller.text
                              });
                            },
                            child: const Center(
                              child: Text(
                                'Зарегистрировать',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ClickackbleText(
                            color: Colors.black,
                            command: 'Зарегистрируйтесь через Google',
                            callback: (context) {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleLogin();
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Есть аккаунт? ",
                          ),
                          ClickackbleText(
                            color: Colors.black,
                            command: 'Войти',
                            callback: (context) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const SignInPage())));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

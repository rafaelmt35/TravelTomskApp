import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/homepage.dart';
import 'package:travel_app/signin_service/signin.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.black,
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
                      const SizedBox(
                        height: 40,
                      ),
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
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      textFieldandCommand(emailcontroller, 'Email Address',
                          'Enter your email address'),
                      textFieldandCommand(usernamecontroller, 'Username',
                          'Enter your username'),
                      textFieldandCommand(passwordcontroller, 'Password',
                          'Enter your password'),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 180,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: maincolor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SignInPage())));
                            },
                            child: Center(
                              child: Text(
                                'Sign Up',
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
                          const Text(
                            "Have Account? ",
                          ),
                          ClickackbleText(
                            color: Colors.black,
                            command: 'Sign in',
                            callback: (context) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SignInPage())));
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

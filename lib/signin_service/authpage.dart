import 'package:flutter/material.dart';
import 'package:travel_app/signin_service/signin.dart';
import 'package:travel_app/signin_service/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin ? const SignInPage() : const SignUpPage();
  }

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}

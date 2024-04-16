// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/homepage.dart';
import 'package:travel_app/signin_service/googlesignin.dart';
import 'package:travel_app/signin_service/signin.dart';
import 'package:travel_app/signin_service/signup.dart';
import 'package:travel_app/test.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => GoogleSignInProvider()),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const InitialPage(),
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (snapshot.hasData) {
            return const HomePage(
              signInWithoutGoogle: true,
            );
          } else {
            return const SignUpPage();
          }
        },
      ),
    );
  }
}

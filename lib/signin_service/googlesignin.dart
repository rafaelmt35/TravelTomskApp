// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleuser = await googleSignIn.signIn();
    if (googleuser == null) return;
    _user = googleuser;

    final googleAuth = await googleuser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    notifyListeners();
  }

  Future googleLogOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

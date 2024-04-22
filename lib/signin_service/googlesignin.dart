// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
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

    final authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final user = authResult.user;

    await FirebaseFirestore.instance
        .collection('Account')
        .doc(user!.uid)
        .set({'email': user.email, 'uid': user.uid, 'username': user.email});
    notifyListeners();
  }

  Future googleLogOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

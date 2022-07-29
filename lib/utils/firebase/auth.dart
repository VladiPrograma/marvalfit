
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/string.dart';
import '../../widgets/marval_snackbar.dart';

void ResetPassword(BuildContext context, String email){
  FirebaseAuth.instance.sendPasswordResetEmail(email: email)
      .then((value) {
    MarvalSnackBar(context, SNACKTYPE.success, title: kResetPasswordSuccesTitle, subtitle: kResetPasswordSucessSubtitle);
  }).catchError((error){
    MarvalSnackBar(context, SNACKTYPE.alert, title: kResetPasswordErrorTitle, subtitle: kResetPasswordErrorSubtitle);
  });
}

Future<String?> LogIn(String email, String password) async{
  try {
    final credential = await FirebaseAuth.instance.
    signInWithEmailAndPassword(
        email: email,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') { return kInputErrorEmail; }
    else if (e.code == 'wrong-password') { return kInputErrorPassword; }
  }
  return null;
}

bool LogOut() {
  bool success = false;
   FirebaseAuth.instance.signOut()
      .whenComplete(() => success =  true)
      .onError((error, stackTrace) => success = false);
  return success;
}

User? getCurrUser(){  return FirebaseAuth.instance.currentUser; }
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/widgets/marval_snackbar.dart';

import '../utils/marval_arq.dart';
import '../utils/objects/user.dart';

/// - - - FIREBASE AUTH - - -  */
 late User authUser;
 late MarvalUser user;

Creator<MarvalUser> userCreator = Creator.value(MarvalUser.empty());

final authEmitter = Emitter.stream((n) => FirebaseAuth.instance.authStateChanges());
final userEmitter = Emitter.stream((ref) async {
 final authId = await ref.watch(
     authEmitter.where((auth) => isNotNull(auth)).map((auth) => auth!.uid));
 return FirebaseFirestore.instance.collection('users').doc(authId).snapshots();
});

MarvalUser? watchUser(BuildContext context, Ref ref){
  final query = ref.watch(userEmitter.asyncData).data;
  if(isNull(query)) return null;
  MarvalUser auxUser =  MarvalUser.fromJson(query!.data()!);
  if(auxUser.active) return auxUser;
  
  Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
  MarvalSnackBar(context, SNACKTYPE.alert,
  title: 'Tu cuenta ha sido desactivada',
  subtitle: ' El adiós siempre es doloroso. Prefiero un ¡hasta pronto!');
  return null;
}

/// HOME VARIABLES */
late ValueNotifier<DateTime> dateNotifier;
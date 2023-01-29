import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/firebase/dailys/logic/daily_logic.dart';
import 'package:marvalfit/firebase/plan/logic/plan_logic.dart';
import 'package:marvalfit/firebase/users/logic/user_logic.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/utils/objects/user.dart';
import 'package:marvalfit/widgets/marval_snackbar.dart';


/// - - - Auth - - - */
final authEmitter = Emitter.stream((n) => FirebaseAuth.instance.authStateChanges());
String? uid = FirebaseAuth.instance.currentUser?.uid;


/// - - - Logic Inits - - -  */
final UserLogic userLogic = UserLogic();
final DailyLogic dailyLogic = DailyLogic();
final PlanLogic planLogic = PlanLogic();
/// - - - FIREBASE AUTH - - -  */
 late User authUser;
 late MarvalUser user;

Creator<MarvalUser> userCreator = Creator.value(MarvalUser.empty());

final userEmitter = Emitter.stream((ref) async {
 final authId = await ref.watch(
     authEmitter.where((auth) => isNotNull(auth)).map((auth) => auth!.uid));
 return FirebaseFirestore.instance.collection('users').doc(authId).snapshots();
});

MarvalUser? watchActiveUser(BuildContext context, Ref ref){
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

MarvalUser? getUser(BuildContext context, Ref ref){
  final query = ref.watch(userEmitter.asyncData).data;
  if(isNull(query)) return null;
  return  MarvalUser.fromJson(query!.data()!);
}

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
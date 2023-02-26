import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/firebase/dailys/logic/daily_logic.dart';
import 'package:marvalfit/firebase/dailys/model/cardio.dart';
import 'package:marvalfit/firebase/exercises/logic/exercise_logic.dart';
import 'package:marvalfit/firebase/gallery/logic/gallery_logic.dart';
import 'package:marvalfit/firebase/gym_notes/logic/gym_notes_logic.dart';
import 'package:marvalfit/firebase/measures/logic/measures_logic.dart';
import 'package:marvalfit/firebase/messages/logic/messages_logic.dart';
import 'package:marvalfit/firebase/plan/logic/plan_logic.dart';
import 'package:marvalfit/firebase/storage/controller/storage_controller.dart';
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
final MeasuresLogic measuresLogic = MeasuresLogic();
final GymNotesLogic gymNotesLogic  = GymNotesLogic();
final GalleryLogic galleryLogic = GalleryLogic();
final ExerciseLogic exerciseLogic = ExerciseLogic();
final MessagesLogic messagesLogic = MessagesLogic();
final StorageController storageController = StorageController();
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

Map<CardioType, String> cardioNames = {
  CardioType.WALK : "🚶Andar",
  CardioType.RUN : "🏃Correr",
  CardioType.CICLING : "🚴Bici",
  CardioType.SWIM : "🏊Nadar",
  CardioType.DANCE : "🕺Bailar",
  CardioType.OTHER : "🏓Otro",
};
Map<CardioMeasure, String> cardioMeasureNames = {
  CardioMeasure.CAL : "Cal",
  CardioMeasure.MINS : "Mins",
  CardioMeasure.STEPS : "Pasos",
  CardioMeasure.KM : "Km",
};

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
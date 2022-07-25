import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/utils/marval_arq.dart';

class CurrentUser{
  static CollectionReference currentUserDB = FirebaseFirestore.instance.collection("users_curr");
  String id;
  int? steps;
  List<String>? habits;
  List<dynamic>? activities;
  DateTime lastUpdate;

  CurrentUser({required this.id, this.habits, this.steps, this.activities,required this.lastUpdate});

  CurrentUser.create({this.habits, this.steps, this.activities})
      : id = FirebaseAuth.instance.currentUser!.uid,
        lastUpdate = DateTime.now();

  CurrentUser.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        habits = List<String>.from(map["habits"]),
        steps = map["steps"],
        activities  = List<dynamic>.from(List<dynamic>.from(map["activities"])),
        lastUpdate = map["last_update"].toDate();


  static Future<bool> currentUserExists(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await currentUserDB.doc(uid).get();
    return ds.exists;

  }



  static Future<CurrentUser> getFromBD(String uid) async {
    DocumentSnapshot doc = await currentUserDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return CurrentUser.fromJson(map!);
  }

  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return currentUserDB
        .doc(id).set({
      'id': id, // UID
      'steps': steps, // 1012
      'habits': habits, // ["Frio", "Agradecer", "Sol"]]
      'activities': activities, // {Descanso : { icon: 'sleep', label: 'Descanso', type: 'Sleep', id: ACT_001 }}
      'last_update' : lastUpdate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Current Training Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to Add User Current Training: $error"));
  }

  Future<void> uploadCurrentUser(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return currentUserDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Current Training Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload User Current Training: $error"));
  }

  @override
  String toString() {
    return ">> ID: $id"
        "\n Steps: $steps"
        "\n Habits: $habits"
        "\n Activities: $activities"
        "\n Last Update: $lastUpdate";
  }

}



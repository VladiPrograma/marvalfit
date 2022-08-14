import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';

class Planing{
  static CollectionReference planingDB = FirebaseFirestore.instance.collection("trainings");
  String id;
  int? steps;
  DateTime lastUpdate;
  List<String>? habits;
  List<Map<String, dynamic>>? activities;

  Planing({
    required this.id,
    required this.lastUpdate,
    this.habits,
    this.steps,
    this.activities
  });

  Planing.create({this.habits, this.steps, this.activities})
      : id = authUser.uid,
        lastUpdate = DateTime.now();

  Planing.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        habits = List<String>.from(map["habits"]),
        steps = map["steps"],
        ///@TODO Check this code and improve it.
        activities  = List<Map<String, dynamic>>.from(List<dynamic>.from(map["activities"])),
        lastUpdate = map["last_update"].toDate();

  static Future<bool> PlaningExists(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await planingDB.doc(uid).get();
    return ds.exists;
  }

  static Future<Planing> getFromBD(String uid) async {
    DocumentSnapshot doc = await planingDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return Planing.fromJson(map!);
  }

  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return planingDB.doc(id).set({
      'id': id, // UID
      'steps': steps, // 1012
      'habits': habits, // ["Frio", "Agradecer", "Sol"]]
      'activities': activities, // {Descanso : { icon: 'sleep', label: 'Descanso', type: 'Sleep', id: ACT_001 }}
      'last_update' : lastUpdate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Current Training Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to Add User Current Training: $error"));
  }

  Future<void> uploadPlaning(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return planingDB
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



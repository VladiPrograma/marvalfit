import 'package:cloud_firestore/cloud_firestore.dart';

import    '../marval_arq.dart';
import '../../config/log_msg.dart';
import '../../utils/extensions.dart';

import '../../constants/string.dart';
import '../../constants/global_variables.dart';

class Daily {

  static CollectionReference dailyDB = FirebaseFirestore.instance.collection("users/${authUser.uid}/daily");

  String   id;
  DateTime date;
  int      sleep;
  double   weight;
  int?     steps;
  List<String> habits;
  List<Map<String, dynamic>> activities;
  List<Map<String, dynamic>>? habitsFromPlaning;

  Daily({
    required this.id,
    required this.date,
    required this.sleep,
    required this.weight,
    required this.habits,
    required this.habitsFromPlaning,
    required this.activities,
    this.steps,
  });

  Daily.create({required this.date, required this.habitsFromPlaning, required this.activities})
  : id = date.id,
    sleep = 0,
    weight = 0,
    steps = 0,
    habits = [];

  Daily.fromJson(Map<String, dynamic> map)
  : id = map["id"],
    date = map["date"].toDate(),
    sleep = map["sleep"],
    weight = map["weight"],
    steps = map["steps"],
    habits = List<String>.from(map["habits"]),
    activities  = List<Map<String, dynamic>>.from(map["activities"]),
    habitsFromPlaning =List<Map<String, dynamic>>.from(List<dynamic>.from(map["habits_from_planing"]));

  Future<void> setInDB() {
    // Call the user's CollectionReference to add a new user
    return dailyDB.doc(id).set({
      'id': id, // UID
      'date': date, // 12/05/2022
      'sleep': sleep, //1
      'weight': weight, // 75.5
      'steps': steps ?? 0, // 75.5
      'habits': habits, // [Sol, Frio, Agradecer]
      'habits_from_planing': habitsFromPlaning, // [Sol, Frio, Agradecer]
      'activities': activities, // {}
    }).then((value) => logSuccess("$logSuccessPrefix User Daily  Added"))
      .catchError((error) => logError("$logErrorPrefix Failed to add User Daily : $error"));
  }

  Future<void> uploadInDB(Map<String, Object> map) {
    // Call the user's CollectionReference to add a new user
    return dailyDB.doc(id).update(map)
          .then((value) => logSuccess("$logSuccessPrefix User Daily Uploaded"))
          .catchError((error) => logError("$logErrorPrefix Failed to Upload User Daily : $error"));
  }

  static Future<bool> existsInDB(DateTime date) async {
    if (isNull(authUser)) { return false; }
    DocumentSnapshot ds = await dailyDB.doc(date.id).get();
    return ds.exists;
  }

  static Future<Daily> getFromDB(DateTime date) async {
    DocumentSnapshot doc = await dailyDB.doc(date.id).get();
    Map<String, dynamic>? map = toMap(doc);
    return Daily.fromJson(map!);
  }

  @override
  String toString() {
    return " ID: $id"
        "\n date: $date"
        "\n Sleep: $sleep/5"
        "\n Weight: $weight Kg"
        "\n Habits: $habits"
        "\n Activities: $activities";
  }

  void updateWeight(double value) {
    weight = double.parse(value.toStringAsPrecision(3));
    uploadInDB({
      "weight": weight,
    });
  }

  void updateSleep(int value) {
    sleep = value;
    uploadInDB({
      "sleep": sleep,
    });
  }
  void updateSteps(int value) {
    steps = value;
    uploadInDB({
      "steps": steps!,
    });
  }
  void updateActivity(Map<String, dynamic> activity) {
    activities[activities.indexOf(activity)] = activity;
    uploadInDB({
      "activities": activities,
    });
  }

  void updateHabits(String value) {
    if (habits.contains(value)) {
      habits.remove(value);
    } else {
      habits.add(value);
    }
    uploadInDB({
      "habits": habits,
    });
  }
}

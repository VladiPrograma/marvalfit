
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../marval_arq.dart';
import '../../config/log_msg.dart';
import '../../constants/string.dart';
import '../../utils/extensions.dart';


///@TODO Check City implementation Works
class Details {
  static CollectionReference detailsDB =  FirebaseFirestore.instance.collection("details");

  String id;
  String favoriteFood;
  String phone;
  String city;
  DateTime birthDate;
  DateTime startDate;
  double height;
  double initialWeight;

  Details({
    required this.id,
    required this.height,
    required this.favoriteFood,
    required this.phone,
    required this.city,
    required this.initialWeight,
    required this.startDate,
    required this.birthDate
  });

  Details.create({
    required this.height,
    required this.favoriteFood,
    required this.phone,
    required this.city,
    required this.birthDate,
    required this.initialWeight})
      : id = FirebaseAuth.instance.currentUser!.uid,
        startDate = DateTime.now();

  Details.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        city = map['city'],
        phone = map["phone"],
        height = map["height"],
        favoriteFood = map["favorite_food"],
        initialWeight = map["initial_weight"],
        birthDate = map["birth_date"].toDate(),
        startDate = map["start_date"].toDate();

  Future<void> setDetails() {
    // Call the user's CollectionReference to add a new user
    return detailsDB.doc(id).set({
      'id': id, // UID
      'phone': phone, // Vlad
      'city': city, // Programador
      'favorite_food': favoriteFood, // 76.3
      'birth_date': birthDate, // 77.4
      'start_date': startDate, // 11/07/2022
      'initial_weight': initialWeight, // 11/07/2022
      'height': height, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Details Added"))
        .catchError((error) =>
        logError("$logErrorPrefix Failed to add User Details: $error"));
  }

  Future<void> uploadDetails(Map<String, Object> map) {
    // Call the user's CollectionReference to add a new user
    return detailsDB
        .doc(id)
        .update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Details Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload User Details: $error"));
  }

  static Future<bool> existsInDB(String? uid) async {
    if (isNull(uid)) {
      return false;
    }
    DocumentSnapshot ds = await detailsDB.doc(uid).get();
    return ds.exists;
  }

  static Future<Details> getFromDB(String uid) async {
    DocumentSnapshot doc = await detailsDB.doc(uid).get();
    Map<String, dynamic>? map = toMap(doc);
    return Details.fromJson(map!);
  }

  @override
  String toString() {
    return " ID: $id"
        "\n Favorite Food: $favoriteFood"
        "\n City: $city"
        "\n Birth Date: $birthDate"
        "\n Age: $age"
        "\n Start Date: $startDate"
        "\n Initial Weight: $initialWeight Height: $height";
  }

  int get age => birthDate.fromBirthdayToAge();

}

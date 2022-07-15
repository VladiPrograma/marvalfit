import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvalfit/utils/marval_arq.dart';

import '../../config/log_msg.dart';
import '../../constants/string.dart';

class MarvalUserDetails{
  static CollectionReference detailsDB = FirebaseFirestore.instance.collection("details");
  String id;
  String favoriteFood;
  String hobbie;
  String phone;
  String email;
  DateTime birthDate;
  DateTime startDate;
  double height;
  double initialWeight;

  MarvalUserDetails(this.id, this.height, this.favoriteFood, this.hobbie, this.phone, this.email,  this.initialWeight, this.startDate,this.birthDate );

  MarvalUserDetails.create(this.height, this.favoriteFood, this.hobbie, this.phone,this.birthDate, this.initialWeight) :
        id = FirebaseAuth.instance.currentUser!.uid,
        email = FirebaseAuth.instance.currentUser?.email ?? "",
        startDate = DateTime.now();

  MarvalUserDetails.fromJson(Map<String, dynamic> map):
        id = map["id"],
        phone = map["phone"],
        email = map["email"],
        hobbie = map['hobbie'],
        favoriteFood = map["favorite_food"],
        birthDate = map["birth_date"],
        startDate = map["start_date"],
        initialWeight = map["initial_weight"],
        height = map["height"];

  static Future<MarvalUserDetails> getFromDB(String uid) async {
    DocumentSnapshot doc = await detailsDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return MarvalUserDetails.fromJson(map!);
  }

  Future<void> setUserDetails(){
    // Call the user's CollectionReference to add a new user
    return detailsDB
        .doc(id).set({
      'id': id, // UID
      'phone': phone, // Vlad
      'email': email, // Dumitru
      'hobbie': hobbie, // Programador
      'favorite_food' : favoriteFood, // 76.3
      'birth_date' : birthDate, // 77.4
      'start_date' : startDate, // 11/07/2022
      'initial_weight' : initialWeight, // 11/07/2022
      'height' : height, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Details Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to add User Details: $error"));
  }

  Future<void> uploadUserDetails(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return detailsDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Details Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload User Details: $error"));
  }

  @override
  String toString() {
    return " ID: $id"
        "\n Email: $email Phone: $phone"
        "\n Hobbie: $hobbie"
        "\n Favorite Food: $favoriteFood"
        "\n Birth Date: $birthDate"
        "\n Start Date: $startDate"
        "\n Initial Weight: $initialWeight Height: $height";
  }
}
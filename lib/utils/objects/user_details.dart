import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvalfit/utils/marval_arq.dart';

import '../../config/log_msg.dart';
import '../../constants/string.dart';

///@TODO Check City implementation Works
class UserDetails{
  static CollectionReference detailsDB = FirebaseFirestore.instance.collection("details");
  String id;
  String favoriteFood;
  String hobbie;
  String phone;
  String email;
  String city;
  DateTime birthDate;
  DateTime startDate;
  double height;
  double initialWeight;

  UserDetails(this.id, this.height, this.favoriteFood, this.hobbie, this.phone, this.city, this.email,  this.initialWeight, this.startDate,this.birthDate );

  UserDetails.create(this.height, this.favoriteFood, this.hobbie, this.phone, this.city, this.birthDate, this.initialWeight) :
        id = FirebaseAuth.instance.currentUser!.uid,
        email = FirebaseAuth.instance.currentUser?.email ?? "",
        startDate = DateTime.now();

  UserDetails.fromJson(Map<String, dynamic> map):
        id = map["id"],
        phone = map["phone"],
        email = map["email"],
        hobbie = map['hobbie'],
        city = map['city'],
        favoriteFood = map["favorite_food"],
        birthDate = map["birth_date"].toDate(),
        startDate = map["start_date"].toDate(),
        initialWeight = map["initial_weight"],
        height = map["height"];

  static Future<UserDetails> getFromDB(String uid) async {
    DocumentSnapshot doc = await detailsDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return UserDetails.fromJson(map!);
  }
  Future<void> setUserDetails(){
    // Call the user's CollectionReference to add a new user
    return detailsDB
        .doc(id).set({
      'id': id, // UID
      'phone': phone, // Vlad
      'email': email, // Dumitru
      'hobbie': hobbie, // Programador
      'city': city, // Programador
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
        "\n City: $city"
        "\n Birth Date: $birthDate"
        "\n Start Date: $startDate"
        "\n Initial Weight: $initialWeight Height: $height";
  }

  int getAge(){
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

}
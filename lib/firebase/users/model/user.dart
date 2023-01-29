import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/extensions.dart';

class User {

  String id;
  bool active;
  String name;
  String lastName;
  String objective;
  String work;
  String hobbie;
  String email;
  String phone;
  String city;
  String favoriteFood;
  String? profileImage;
  DateTime? birthdate;
  DateTime startDate;
  DateTime lastUpdate;
  DateTime update;
  double initialWeight;
  double lastWeight;
  double currWeight;
  double height;

  int get age => birthdate?.fromBirthdayToAge() ?? -1;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.work,
    required this.email,
    required this.active,
    required this.hobbie,
    required this.objective,
    required this.lastWeight,
    required this.currWeight,
    required this.update,
    required this.lastUpdate,
    required this.startDate,
    required this.favoriteFood,
    required this.phone,
    required this.city,
    required this.birthdate,
    required this.height,
    required this.initialWeight,
    this.profileImage
  });

  User.empty()
  :   id = "",
      name = "",
      email = "",
      objective = "",
      update = DateTime.now(),
      startDate = DateTime.now(),
      lastUpdate = DateTime.now(),
      lastName = "",
      hobbie = "",
      active = true,
      work = "",
      favoriteFood = "",
      phone = "",
      city = "",
      height = 0,
      initialWeight = 0,
      profileImage = "",
      currWeight = 0,
      lastWeight = 0,
      birthdate = DateTime.now();


  User.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        lastName = map["last_name"],
        hobbie = map["hobbie"],
        objective = map["objective"],
        email = map["email"],
        active = map["active"],
        work = map["work"],
        favoriteFood = map['favorite_food'],
        phone = map['phone'],
        city = map['city'],
        height = map['height'],
        initialWeight = map['initial_weight'],
        profileImage = map["profile_image"],
        currWeight = map["curr_weight"],
        lastWeight = map["last_weight"],
        birthdate = map['birthdate']?.toDate(),
        update = map["update"].toDate(),
        startDate = map["start_date"].toDate(),
        lastUpdate = map["last_update"].toDate();

  Map<String, dynamic> toMap(){
    return {
      'id': id, // UID
      'name': name.normalize(), // Vlad
      'last_name': lastName.normalize(), // Dumitru
      'hobbie': hobbie.normalize(), // Dumitru
      'objective': objective, // Dumitru
      'email': email,
      'favorite_food' : favoriteFood.normalize(),
      'phone' : phone,
      'city' : city.normalize(),
      'birthdate' : birthdate,
      'height'  :height,
      'initial_weight' :initialWeight, // Dumitru
      'active': active, // Dumitru
      'work': work.normalize(), // Programador
      'profile_image': profileImage, // Programador
      'last_weight': lastWeight, // 76.3
      'curr_weight': currWeight, // 77.4
      'update': update, // 11/06/2021
      'last_update': lastUpdate, // 11/07/2022
      'start_date': startDate, // 11/07/2022
    };
  }

  @override
  String toString() {
   return
       "{ UID: $id"
    "\n Name: $name Last Name: $lastName"
    "\n Mail: $email Active: $active"
    "\n Job: $work , Age $age }\n";
  }

  String details(){
   return " ID: $id "
    "\n Start Date: $startDate"
    "\n Mail: $email Active: $active"
    "\n Name: $name Last Name: $lastName"
    "\n Job: $work"
    "\n Curr: $currWeight Kg  Last: $lastWeight Kg "
    "\n Update: $update Last Update: $lastUpdate"
    "\n Hobbie: $hobbie Objective: $objective"
    "\n favoriteFood: $favoriteFood"
    "\n city: $city phone: $phone"
    "\n birthdate: $birthdate"
    "\n height: $height initialWeight: $initialWeight"
    "\n Profile image URL: $profileImage";
  }

}
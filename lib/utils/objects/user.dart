import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/extensions.dart';
import '../../config/log_msg.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';

import 'planing.dart';
import 'user_daily.dart';

class MarvalUser {

  static CollectionReference usersDB = FirebaseFirestore.instance.collection("users");

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
  Planing? currenTraining;
  Map<String, Daily>? dailys;

  MarvalUser({
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

  MarvalUser.create(
      {String? uid, required this.name, required this.email, required this.objective})
      : id = uid ?? FirebaseAuth.instance.currentUser!.uid,
        lastName = '',
        work = '',
        hobbie = '',
        favoriteFood ='',
        phone ='',
        city ='',
        height = 0,
        initialWeight =0,
        active = true,
        lastWeight = 0,
        currWeight = 0,
        dailys = <String, Daily>{},
        update = DateTime.now(),
        startDate = DateTime.now(),
        lastUpdate = DateTime.now();

  MarvalUser.fromJson(Map<String, dynamic> map)
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
        lastUpdate = map["last_update"].toDate(),
        dailys = <String, Daily>{};

  MarvalUser.empty()
      : id = '',
        active = true,
        email = '',
        name = '',
        lastName = '',
        objective = '',
        work = '',
        hobbie = '',
        favoriteFood= '',
        phone= '',
        city= '',
        height= 0,
        initialWeight= 0,
        lastWeight = 0,
        currWeight = 0,
        dailys = <String, Daily>{},
        birthdate= DateTime.now(),
        update = DateTime.now(),
        startDate = DateTime.now(),
        lastUpdate = DateTime.now();

  int get age => birthdate?.fromBirthdayToAge() ?? -1;

  Future<void> setInDB() {
    // Call the user's CollectionReference to add a new user
    return usersDB
        .doc(id).set({
      'id': id, // UID
      'name': name, // Vlad
      'last_name': lastName, // Dumitru
      'hobbie': hobbie, // Dumitru
      'objective': objective, // Dumitru
      'email': email,
      'favorite_food' : favoriteFood,
      'phone' : phone,
      'city' : city,
      'birthdate' : birthdate,
      'height'  :height,
      'initial_weight' :initialWeight, // Dumitru
      'active': active, // Dumitru
      'work': work, // Programador
      'profile_image': profileImage, // Programador
      'last_weight': lastWeight, // 76.3
      'curr_weight': currWeight, // 77.4
      'update': update, // 11/06/2021
      'last_update': lastUpdate, // 11/07/2022
      'start_date': startDate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Added"))
        .catchError((error) =>
        logError("$logErrorPrefix Failed to add user: $error"));
  }

  Future<void> uploadInDB(Map<String, Object> map) {
    // Call the user's CollectionReference to add a new user
    return usersDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Uploaded"))
        .catchError((error) =>
        logError("$logErrorPrefix Failed to Upload user: $error"));
  }

  Future<void> getCurrentTraining() async =>
      currenTraining = await Planing.getFromBD(id);

  Future<void> getDaily(DateTime date) async =>
      dailys![date.id] = await Daily.getFromDB(date);

  static Future<bool> existsInDB(String? uid) async {
    if (isNull(uid)) { return false;  }
    DocumentSnapshot ds = await usersDB.doc(uid).get();
    return ds.exists;
  }

  static Future<bool> isNotRegistered(String? email) async {
    if (isNull(email)) {
      return false;
    }
    return usersDB
        .where('email', isEqualTo: email)
        .snapshots()
        .isEmpty;
  }

  static Future<MarvalUser> getFromDB(String uid) async {
    DocumentSnapshot doc = await usersDB.doc(uid).get();
    Map<String, dynamic>? map = toMap(doc);
    return MarvalUser.fromJson(map!);
  }


  @override
  String toString() {
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
        "\n Profile image URL: $profileImage"
        "\n Current Training: ${currenTraining?.toString()}"
        "\n Dailys: \n${dailys.toString()}";
  }

  ///@TODO Align this methods
  void updateWeight({required double weight, DateTime? date}) {
    lastWeight = currWeight;
    currWeight = weight;

    lastUpdate = update;
    update = date ?? DateTime.now();

    if (lastWeight == 0) {
      lastWeight = weight;
    }
    uploadInDB({
      "last_weight": lastWeight,
      "curr_weight": currWeight,
      "last_update": lastUpdate,
      "update": update
    });
  }

  void updateLastWeight({required double weight, required DateTime date}) {
    lastWeight = weight;
    lastUpdate = date;
    uploadInDB({
      "last_weight": lastWeight,
      "last_update": lastUpdate,
    });
  }

  void updateHobbie({required String hobbie}) {
    this.hobbie = hobbie;
    uploadInDB({
      "hobbie": hobbie,
    });
  }

  void updateEmail({required String email}) {
    this.email = email;
    uploadInDB({
      "email": email,
    });
  }

  void updateActive() {
    active = !active;
    uploadInDB({
      "active": active,
    });
  }

  void updateDetails({required String hobbie, required String city,required String favoriteFood,required DateTime birthdate,required double initialWeight, required double height}){

    this.city =  city;
    this.favoriteFood =  favoriteFood;
    this.birthdate =  birthdate;
    this.height =  height;
    this.hobbie = hobbie;
    this.initialWeight =  initialWeight;

    uploadInDB({
      'phone': this.phone, // Vlad
      'city': this.city, // Programador
      'favorite_food': this.favoriteFood, // 76.3
      'hobbie': this.hobbie, // 76.3
      'birthdate': this.birthdate!, // 77.4
      'initial_weight': this.initialWeight, // 11/07/2022
      'height': this.height, // 11/07/2022
    });
  }

  void updateBasicData({required String name, required String lastName, required String work, required String phone}) {
    this.name = name;
    this.lastName = lastName;
    this.work = work;
    this.phone = phone;
    uploadInDB({
      "name": name,
      "last_name": lastName,
      "work": work,
      "phone": phone,
    });
  }
}
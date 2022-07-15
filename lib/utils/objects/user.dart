import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/utils/objects/user_details.dart';

class MarvalUser{
  static CollectionReference usersDB = FirebaseFirestore.instance.collection("users");
  String id;
  String name;
  String lastName;
  String work;
  String? profileImage;
  double lastWeight;
  double currWeight;
  DateTime lastUpdate;
  MarvalUserDetails? details;

  MarvalUser(this.id, this.name, this.lastName, this.work,this.profileImage, this.lastWeight ,this.currWeight, this.lastUpdate);

  MarvalUser.create(this.name, this.lastName, this.work, this.profileImage, this.lastWeight, this.currWeight)
     : id = FirebaseAuth.instance.currentUser!.uid,
       lastUpdate = DateTime.now();

  MarvalUser.fromJson(Map<String, dynamic> map)
   : id = map["id"],
    name = map["name"],
    lastName = map["last_name"],
    work = map["work"],
    profileImage  = map["profile_image"],
    currWeight = map["curr_weight"],
    lastWeight = map["last_weight"],
    lastUpdate = map["last_update"];

  void getDetails() async => details = await MarvalUserDetails.getFromDB(id);


  static Future<MarvalUser> getFromDB(String uid) async {
    DocumentSnapshot doc = await usersDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return MarvalUser.fromJson(map!);
  }

  Future<void> setMarvalUser(){
    // Call the user's CollectionReference to add a new user
    return usersDB
        .doc(id).set({
      'id': id, // UID
      'name': name, // Vlad
      'last_name': lastName, // Dumitru
      'work': work, // Programador
      'profile_image': profileImage, // Programador
      'last_weight' : lastWeight, // 76.3
      'curr_weight' : currWeight, // 77.4
      'last_update' : lastUpdate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to add user: $error"));
  }

  Future<void> uploadMarvalUser(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return usersDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload user: $error"));
  }

  void updateWeight(double weight){
    if(currWeight == 0){ currWeight = weight; }
    uploadMarvalUser({
      "last_weight" : currWeight,
      "curr_weight" : weight,
      "last_update" : DateTime.now()
    });
  }


  @override
  String toString() {
    return " ID: $id"
    "\n Name: $name Last Name: $lastName"
    "\n Job: $work"
    "\n Curr: $currWeight Kg  Last: $lastWeight Kg "
    "\n Last Update: $lastUpdate"
    "\n Profile image URL: $profileImage";
  }

}



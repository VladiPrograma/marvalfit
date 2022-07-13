import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addUser() {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  // Call the user's CollectionReference to add a new user
  User? user = FirebaseAuth.instance.currentUser;
  if(user==null){
    print(" Null User Exception ");
    return Future.delayed(Duration.zero);
  }
  return users
      .doc(user.uid).set({
    'id': user.uid, // John Doe
    'name': "Juanjo", // Stokes and Sons
    'last_name': "Perico Palotes",
    'work': "Programador",
    'last_weight' : 76.3,
    'curr_weight' : 76.3
     // 42
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}
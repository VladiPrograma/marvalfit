import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/string.dart';


enum MessageType  {text, photo, audio}

class Message{
static CollectionReference chatDB = FirebaseFirestore.instance.collection("users/${authUser!.uid}/chat");

final MessageType type;
final String message;
final DateTime date;
final String user;


Message(this.message, this.type, this.user, this.date);

Message.create(this.message, this.type):
  user = authUser!.uid,
  date = DateTime.now();

Message.fromJson(Map<String, dynamic> map)
    : user = map["user"],
      message = map["message"],
      type = MessageType.values.byName(map["type"]),
      date = map["date"].toDate();

Future<void> setInDB(){
  // Call the user's CollectionReference to add a new user
  return chatDB
      .doc().set({
    'user': user, // UID
    'message': message, // Vlad es tonto
    'type': type.name, // text
    'date': date, // 11/07/2022
  })
      .then((value) => logSuccess("$logSuccessPrefix Message Added"))
      .catchError((error) => logError("$logErrorPrefix Message to add user: $error"));
}

@override
String toString() {
  return " User_ID: $user"
      "\n Message: $message "
      "\n Type: ${type.name}"
      "\n Date: ${date.toFormatStringDate} - ${date.toFormatStringHour()}";
}


}

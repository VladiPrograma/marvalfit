import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';


enum MessageType  {text, photo, audio}

class Message{
  static CollectionReference chatDB = FirebaseFirestore.instance.collection("users/${authUser.uid}/chat");

  final MessageType type;
  String message;
  final DateTime date;
  int duration = 0;
  final String user;
  bool read;


  Message({required this.message,
    required this.type,
    required this.user,
    required this.date,
    required this.read });

  Message.create({required this.message, required this.type}):
        user = authUser.uid,
        read = false,
        date = DateTime.now();

  Message.image():
        user = authUser.uid,
        type = MessageType.photo,
        message = "",
        read = false,
        date = DateTime.now();

  Message.audio(int durations):
        user = authUser.uid,
        type = MessageType.audio,
        duration = durations,
        message = "",
        read = false,
        date = DateTime.now();

  Message.fromJson(Map<String, dynamic> map)
      : user = map["user"],
        message = map["message"],
        read = map["read"],
        type = MessageType.values.byName(map["type"]),
        date = map["date"].toDate(),
        duration = map["duration"] ?? 0;

  Future<String?> addInDB(){
    // Call the user's CollectionReference to add a new user
    return chatDB.add({
      'user': user, // UID
      'message': message, // Vlad es tonto
      'read': read, // Vlad es tonto
      'type': type.name, // text
      'date': date, // 11/07/2022
      'duration' : duration // 25
    }).then((value){
      logSuccess("$logSuccessPrefix Message Added");
      return value.id;
    }).catchError((error){
      logError("$logErrorPrefix Failed to add Message: $error");
      return null;
    });
  }


  Future<void> setInDB(String docID){
    return chatDB.doc(docID).set({
      'user': user, // UID
      'message': message, // Vlad es tonto
      'read': read, // Vlad es tonto
      'type': type.name, // text
      'date': date, // 11/07/2022
      'duration': duration, // 11/07/2022
    }).then((value)=> logSuccess("$logSuccessPrefix Message Set"))
        .catchError((error) => logError("$logErrorPrefix Failed to add Message: $error"));
  }

  Future<void> uploadInDB(Map<String, Object> map) async{
    // Call the user's CollectionReference to add a new user
    final query = await chatDB.where('date', isEqualTo: date).limit(1).get();

    if(isNull(query)||query.size == 0){ return;}

    return chatDB
        .doc(query.docs.first.reference.id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix Message Updated"))
        .catchError((error) => logError("$logErrorPrefix Failed to update Message: $error"));
  }

  @override
  String toString() {
    return " User_ID: $user"
        "\n Message: $message "
        "\n Type: ${type.name}"
        "\n Duration: ${duration==0 ? "None" : duration}"
        "\n Read: $read"
        "\n Date: ${date.toFormatStringDate} - ${date.toFormatStringHour()}";
  }


  void updateRead(){
    if(!read) {
      read = true;
      uploadInDB({  "read": read, });
    }
  }

}

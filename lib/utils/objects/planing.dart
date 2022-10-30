import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/utils/extensions.dart';
import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';

class Planing{
  static DateTime finalDate = DateTime(3000, 12, 12);
  static CollectionReference planingDB = FirebaseFirestore.instance.collection("users/${authUser.uid}/planing");
  String id;
  String uid;
  int? steps;
  DateTime endDate;
  DateTime startDate;
  DateTime lastUpdate;
  List<Map<String, dynamic>>? habits;
  List<Map<String, dynamic>>? activities;

  Planing({
    required this.id,
    required this.uid,
    required this.lastUpdate,
    required this.startDate,
    required this.endDate,
    this.habits,
    this.steps,
    this.activities
  });

  Planing.create({this.habits, this.steps, this.activities})
      : id = DateTime.now().add(const Duration(days: 1)).cropTime().id,
        uid = authUser.uid,
      //@TODO Add one day to the startDate
        lastUpdate = DateTime.now().add(const Duration(days: 1)).cropTime(),
        startDate  = DateTime.now().add(const Duration(days: 1)).cropTime(),
        endDate    = finalDate;

  Planing.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        uid = map["uid"],
        steps = map["steps"],
        ///@TODO Check this code and improve it.
        habits = List<Map<String, dynamic>>.from(List<dynamic>.from(map["habits"])),
        activities  = List<Map<String, dynamic>>.from(List<dynamic>.from(map["activities"])),
        lastUpdate = map["last_update"].toDate(),
        startDate = map["start_date"].toDate(),
        endDate = map["end_date"].toDate();

  static Future<bool> planingExists(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await planingDB.doc(uid).get();
    return ds.exists;
  }

  static Future<Planing> getFromBD(DateTime date) async{
    final query = await FirebaseFirestore.instance.collection('users/${authUser.uid}/planing')
          .where("end_date", isGreaterThanOrEqualTo: date).get();
    if(query.docs.length == 1){
      final planingSnapshot = query.docs.first;
      return Planing.fromJson(planingSnapshot.data());
    }
    List<Planing> planings = [];
    for(final doc in query.docs ){
      planings.add(Planing.fromJson(doc.data()));
    }
    return planings.where((element) => element.startDate.isBefore(date)).first;
  }
  static Future<Planing> getCurrentFromBD() async{
    final query = await FirebaseFirestore.instance.collection('users/${authUser.uid}/planing')
        .where("end_date", isEqualTo: finalDate).get();

    final planingSnapshot = query.docs.first;
    return Planing.fromJson(planingSnapshot.data());
  }


  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return planingDB.doc(id).set({
      'id': id, // UID
      'uid': uid, // UID
      'steps': steps, // 1012
      'habits': habits, // ["Frio", "Agradecer", "Sol"]]
      'activities': activities, // {Descanso : { icon: 'sleep', label: 'Descanso', type: 'Sleep', id: ACT_001 }}
      'last_update' : lastUpdate, // 11/07/2022
      'start_date' : startDate, // 11/07/2022
      'end_date' : endDate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Current Planing Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to Add User Current Planing: $error"));
  }

  Future<void> uploadPlaning(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return planingDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Current Planing Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload User Current Planing: $error"));
  }

  @override
  String toString() {
    return ">> ID: $id"
        "\n Start Date: ${startDate.id}"
        "\n End Date: ${endDate.id}"
        "\n Steps: $steps"
        "\n Habits: $habits"
        "\n Activities: $activities"
        "\n Last Update: $lastUpdate";
  }

  static Planing createNewPlaning(){
    Planing training = Planing.create(
      habits: [],
      steps: 10000,
      activities:
      [ { "icon": 'sleep', "label": 'Descanso', "type": 'rest', "id": 'DESCANSO'},
        { "icon": 'tap', "label": 'Medidas', "type": 'table', "id": 'MEDIDAS'},
        { "icon": 'gallery', "label": 'Galeria', "images": 'Sleep', "id": 'FOTOS'},
        { "icon": 'steps', "label": 'Pasos', "type": 'steps', "id": 'PASOS'}
      ],
    );
    training.setInDB();
    return training;
  }

}



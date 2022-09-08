import 'package:cloud_firestore/cloud_firestore.dart';
import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';

class Planing{
  static CollectionReference planingDB = FirebaseFirestore.instance.collection("trainings");
  String id;
  int? steps;
  DateTime lastUpdate;
  List<Map<String, dynamic>>? habits;
  List<Map<String, dynamic>>? activities;

  Planing({
    required this.id,
    required this.lastUpdate,
    this.habits,
    this.steps,
    this.activities
  });

  Planing.create({this.habits, this.steps, this.activities})
      : id = authUser.uid,
        lastUpdate = DateTime.now();

  Planing.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        steps = map["steps"],
        ///@TODO Check this code and improve it.
        habits = List<Map<String, dynamic>>.from(List<dynamic>.from(map["habits"])),
        activities  = List<Map<String, dynamic>>.from(List<dynamic>.from(map["activities"])),
        lastUpdate = map["last_update"].toDate();

  static Future<bool> PlaningExists(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await planingDB.doc(uid).get();
    return ds.exists;
  }

  static Future<Planing> getFromBD(String uid) async {
    DocumentSnapshot doc = await planingDB.doc(uid).get();
    Map<String, dynamic>? map  = toMap(doc);
    return Planing.fromJson(map!);
  }

  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return planingDB.doc(id).set({
      'id': id, // UID
      'steps': steps, // 1012
      'habits': habits, // ["Frio", "Agradecer", "Sol"]]
      'activities': activities, // {Descanso : { icon: 'sleep', label: 'Descanso', type: 'Sleep', id: ACT_001 }}
      'last_update' : lastUpdate, // 11/07/2022
    })
        .then((value) => logSuccess("$logSuccessPrefix User Current Training Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to Add User Current Training: $error"));
  }

  Future<void> uploadPlaning(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return planingDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User Current Training Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload User Current Training: $error"));
  }

  @override
  String toString() {
    return ">> ID: $id"
        "\n Steps: $steps"
        "\n Habits: $habits"
        "\n Activities: $activities"
        "\n Last Update: $lastUpdate";
  }

  static Planing createNewTraining(){
    Planing training = Planing.create(habits: [
       {'label' : 'Sol',
        'name' : 'Tomar el Sol',
        'description' :
          'La luz solar puede mejorar nuestro estado de ánimo, disminuir la presión arterial, '
          'fortalecer nuestros huesos, músculos e incluso nuestro sistema inmunológico.'
          'Y una breve exposición es suficiente para cosechar todos estos beneficios.'
      },
      {'label' : 'Frio',
        'name' : 'Exposición al Frio',
        'description' :
          'La exposición al frío mejora el sistema inmunitario, aumenta el metabolismo,'
          ' ayuda a quemar grasa, y mejora los síntomas de la depresión.'
          'La adaptación requiere constancia, y eso quiere decir pasar frío a diario.'
      },
      {'label' : 'Naturaleza',
        'name' : 'La Naturaleza y Tu',
        'description' :
          'La cantidad de energía que nos ofrece la naturaleza estimula nuestras neuronas '
          'y esto favorece nuestro desarrollo cognitivo y aprendizaje. Movernos libremente'
          ' y observar despierta tu curiosidad e interés por conocer y saber un poco más de ella. '
      }
    ],
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



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';


const String idGallery = '_Gallery';

class Gallery {
  static CollectionReference activitiesDB = FirebaseFirestore.instance.collection(
      "users/${authUser.uid}/activities");

  late final String id;
  late final String type;
  final DateTime date;
  String? frontal;
  String? perfil;
  String? espalda;
  String? piernas;

  Gallery({
    required this.date,
     this.frontal,
     this.perfil,
     this.espalda,
     this.piernas,
  }) {
    id = date.id + idGallery;
    type =  idGallery;
  }

  Map<String, String?> getPhotos(){
    return <String, String?>{
      'frontal' : frontal,
      'perfil' : perfil,
      'espalda' : espalda,
      'piernas' : piernas
    };
  }
  Gallery.fromMap({required this.date, required Map<String, String?> map})
      :
        id = date.id + idGallery,
        type =  idGallery,
        frontal = map['frontal'],
        perfil  = map['perfil' ],
        espalda = map['espalda'],
        piernas = map['piernas'];


  Gallery.create({required this.date})
      :
        id = date.id + idGallery,
        type = idGallery,
        frontal = null,
        perfil = null,
        espalda = null,
        piernas = null;


  Gallery.fromJson(Map<String, dynamic> map)
      :
        id= map['id'],
        type= map['type'],
        date= map['date'].toDate(),
        frontal = map['frontal'],
        perfil = map['perfil'],
        espalda = map['espalda'],
        piernas = map['piernas'];

  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return activitiesDB.doc(id).set({
      'id'   : id, //35.5
      'type'   : type, //35.5
      'date' : date, //35.5
      'frontal' : frontal,
      'perfil' : perfil,
      'espalda' : espalda,
      'piernas' : piernas
    }).then((value) { logSuccess("$logSuccessPrefix Gallery Added");
    }).catchError((error) => logError("$logErrorPrefix Failed to add Gallery: $error"));
  }

  static Future<bool> exists(DateTime? date) async{
    if(isNull(date)){ return false;}
    DocumentSnapshot ds = await activitiesDB.doc(date!.id+idGallery).get();
    return ds.exists;
  }

  static Future<Gallery> getFromBD(DateTime date) async {
    DocumentSnapshot doc = await activitiesDB.doc(date.id+idGallery).get();
    Map<String, dynamic>? map  = toMap(doc);
    return Gallery.fromJson(map!);
  }

  Future<void> upload(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return activitiesDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User  Gallery Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload  Gallery : $error"));
  }

  @override
  String toString() {
    return "ID : $id"
        "\n type : $type"
        "\n date : ${date.id}"
        "\n frontal : $frontal"
        "\n perfil : $perfil"
        "\n espalda : $espalda"
        "\n piernas : $piernas";
  }

}

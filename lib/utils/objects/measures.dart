import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../marval_arq.dart';


const String idMeasures = '_Measures';

class Measures {
  static CollectionReference activitiesDB = FirebaseFirestore.instance.collection(
      "users/${authUser.uid}/activities");

  late final String id;
  late final String type;
  final DateTime date;
  final double ombligo;
  final double ombligoP2;
  final double ombligoM2;
  final double cadera;
  final double contPecho;

  final double contHombros;
  final double gemeloIzq;
  final double gemeloDrch;
  final double musloIzq;
  final double musloDrch;
  final double bicepsIzq;
  final double bicepsDrch;


  Measures({
    required this.date,
    required this.ombligo,
    required this.ombligoP2,
    required this.ombligoM2,
    required this.cadera,
    required this.contPecho,
    required this.contHombros,
    required this.gemeloIzq,
    required this.gemeloDrch,
    required this.musloIzq,
    required this.musloDrch,
    required this.bicepsIzq,
    required this.bicepsDrch,
  }) {
    id = date.id + idMeasures;
    type = idMeasures;
  }
  
  Map<String, double> bodyParts(){
    return <String, double>{
      'Ombligo' : ombligo,
      'Ombligo +2cm' : ombligoP2,
      'Ombligo -2cm' : ombligoM2,
      'Cadera' : cadera,
      'Cont. Pecho' : contPecho,
      'Cont. Hombros' : contHombros,
      'Gemelo izq' : gemeloIzq,
      'Gemelo drch' : gemeloDrch,
      'Muslo izq' : musloIzq,
      'Muslo drch' : musloDrch,
      'Biceps izq' : bicepsIzq,
      'Biceps drch' : bicepsDrch,
    };
  }
  Measures.fromMap({required this.date, required Map<String, double> map})
  :
  id = date.id + idMeasures,
  type =  idMeasures,
  ombligo= map['Ombligo']!,
  ombligoP2=map['Ombligo +2cm']!,
  ombligoM2=map['Ombligo -2cm']!,
  cadera=map['Cadera']!,
  contPecho=map['Cont. Pecho']!,
  contHombros=map['Cont. Hombros']!,
  gemeloIzq=map['Gemelo izq']!,
  gemeloDrch=map['Gemelo drch']!,
  musloIzq=map['Muslo izq']!,
  musloDrch=map['Muslo drch']!,
  bicepsIzq=map['Biceps izq']!,
  bicepsDrch=map['Biceps drch']!;
      
  
  Measures.create({required this.date})
  :
  id = date.id + idMeasures,
  type =  idMeasures,
  ombligo=0,
  ombligoP2=0,
  ombligoM2=0,
  cadera=0,
  contPecho=0,
  contHombros=0,
  gemeloIzq=0,
  gemeloDrch=0,
  musloIzq=0,
  musloDrch=0,
  bicepsIzq=0,
  bicepsDrch=0;
  
  
  Measures.fromJson(Map<String, dynamic> map)
  : 
  id= map['id'],
  type= map['type'],
  date= map['date'].toDate(),
  ombligo= map['ombligo'],
  ombligoP2= map['ombligo_p2'],
  ombligoM2= map['ombligo_m2'],
  cadera= map['cadera'],
  contPecho= map['cont_pecho'],
  contHombros= map['cont_hombros'],
  gemeloIzq= map['gemelo_izq'],
  gemeloDrch= map['gemelo_drch'],
  musloIzq= map['muslo_izq'],
  musloDrch= map['muslo_drch'],
  bicepsIzq= map['biceps_izq'],
  bicepsDrch= map['biceps_drch'];

  Future<void> setInDB(){
    // Call the user's CollectionReference to add a new user
    return activitiesDB.doc(id).set({
          'id':id, //35.5
          'type':type, //35.5
          'date':date, //35.5
          'ombligo': ombligo, //35.5
          'ombligo_p2': ombligoP2, //35.5
          'ombligo_m2': ombligoM2, //35.5
          'cadera': cadera, //35.5
          'cont_pecho': contPecho, //35.5
          'cont_hombros': contHombros, //35.5
          'gemelo_izq': gemeloIzq, //35.5
          'gemelo_drch': gemeloDrch, //35.5
          'muslo_izq': musloIzq, //35.5
          'muslo_drch': musloDrch, //35.5
          'biceps_izq': bicepsIzq, //35.5
          'biceps_drch': bicepsDrch, //35.5
    })
        .then((value) { logSuccess("$logSuccessPrefix Measures Added");
        }).catchError((error) => logError("$logErrorPrefix Failed to add Measures: $error"));
  }

  static Future<bool> measuresExists(DateTime? date) async{
    if(isNull(date)){ return false;}
    DocumentSnapshot ds = await activitiesDB.doc(date!.id+idMeasures).get();
    return ds.exists;
  }

  static Future<Measures> getFromBD(DateTime date) async {
    DocumentSnapshot doc = await activitiesDB.doc(date.id+idMeasures).get();
    Map<String, dynamic>? map  = toMap(doc);
    return Measures.fromJson(map!);
  }

  Future<void> uploadMeasures(Map<String, Object> map){
    // Call the user's CollectionReference to add a new user
    return activitiesDB
        .doc(id).update(map)
        .then((value) => logSuccess("$logSuccessPrefix User  Measures Uploaded"))
        .catchError((error) => logError("$logErrorPrefix Failed to Upload  Measures : $error"));
  }

  @override
  String toString() {
    return "ID : $id"
    "\n type : $type"
    "\n date : ${date.id}"
    "\n ombligo : $ombligo"
    "\n ombligo_p2 : $ombligoP2"
    "\n ombligo_m2 : $ombligoM2"
    "\n cadera : $cadera"
    "\n cont_pecho : $contPecho"
    "\n cont_hombros : $contHombros"
    "\n gemelo_izq : $gemeloIzq"
    "\n gemelo_drch : $gemeloDrch"
    "\n muslo_izq : $musloIzq"
    "\n muslo_drch : $musloDrch"
    "\n biceps_izq : $bicepsIzq"
    "\n biceps_drch : $bicepsDrch";
  }

}

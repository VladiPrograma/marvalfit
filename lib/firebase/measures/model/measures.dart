import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/utils/extensions.dart';

// @TODO change "_Measures" with "Measures"
class Measures{
   String id;
   ActivityType type =  ActivityType.MEASURES;
   DateTime date;
   double ombligo;
   double ombligoP2;
   double ombligoM2;
   double cadera;
   double contPecho;
   double contHombros;
   double gemeloIzq;
   double gemeloDrch;
   double musloIzq;
   double musloDrch;
   double bicepsIzq;
   double bicepsDrch;

   Measures({
    required this.id,
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
  });
   Measures.create({required this.date})
       :
         id = '${date.id}_${ActivityType.MEASURES}',
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

   Measures.fromMap(Map<String, dynamic> map)
       : id = map['id'],
         type = ActivityType.values.byName(map['type']),
         date = map['date'].toDate(),
         ombligo = map['ombligo'],
         ombligoP2 = map['ombligo_p2'],
         ombligoM2 = map['ombligo_m2'],
         cadera = map['cadera'],
         contPecho = map['cont_pecho'],
         contHombros = map['cont_hombros'],
         gemeloIzq = map['gemelo_izq'],
         gemeloDrch = map['gemelo_drch'],
         musloIzq = map['muslo_izq'],
         musloDrch = map['muslo_drch'],
         bicepsIzq = map['biceps_izq'],
         bicepsDrch = map['biceps_drch'];

   Map<String, dynamic> toMap(){
     return {
       'id' : id,
       'type' : type.name,
       'date' : date,
       'ombligo' : ombligo,
       'ombligo_p2' : ombligoP2,
       'ombligo_m2' : ombligoM2,
       'cadera' : cadera,
       'cont_pecho' : contPecho,
       'cont_hombros' : contHombros,
       'gemelo_izq' : gemeloIzq,
       'gemelo_drch' : gemeloDrch,
       'muslo_izq' : musloIzq,
       'muslo_drch' : musloDrch,
       'biceps_izq' : bicepsIzq,
       'biceps_drch' : bicepsDrch,
     };
   }

   @override
  String toString() {
    return 'Measures{id: $id, type: $type, date: $date, ombligo: $ombligo, ombligoP2: $ombligoP2, ombligoM2: $ombligoM2, cadera: $cadera, contPecho: $contPecho, contHombros: $contHombros, gemeloIzq: $gemeloIzq, gemeloDrch: $gemeloDrch, musloIzq: $musloIzq, musloDrch: $musloDrch, bicepsIzq: $bicepsIzq, bicepsDrch: $bicepsDrch}';
  }
}
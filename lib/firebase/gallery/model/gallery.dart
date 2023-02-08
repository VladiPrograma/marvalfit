import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/utils/extensions.dart';

// @TODO if we are uploading images to DB change 'String' to 'Loading...' to permit the handle during the update. xd
// @TODO change "_Measures" with "Measures"
class Gallery {

  String id;
  ActivityType type =  ActivityType.GALLERY;
  DateTime date;
  String? frontal;
  String? perfil;
  String? espalda;
  String? piernas;

  Gallery({ required this.id, required this.date, this.frontal, this.espalda, this.perfil, this.piernas });

  Gallery.create({required this.date})
    :id = '${date.id}_${ActivityType.GALLERY}',
     type = ActivityType.GALLERY,
     frontal = '',
     perfil = '',
     espalda = '',
     piernas = '';

  Gallery.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        type = ActivityType.values.byName(map['type']),
        date = map['date'].toDate(),
        frontal = map['frontal'],
        perfil  = map['perfil'],
        espalda = map['espalda'],
        piernas = map['piernas'];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'type' : type.name,
      'date' : date,
      'frontal' : frontal,
      'perfil' : perfil ,
      'espalda' : espalda ,
      'piernas' : piernas ,
    };
  }

  @override
  String toString() {
    return 'Gallery{id: $id, type: $type, date: $date, frontal: $frontal, perfil: $perfil, espalda: $espalda, piernas: $piernas}';
  }
}
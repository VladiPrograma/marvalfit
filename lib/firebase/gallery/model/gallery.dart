import 'package:marvalfit/utils/extensions.dart';

// @TODO if we are uploading images to DB change 'String' to 'Loading...' to permit the handle during the update. xd
// @TODO change "_Measures" with "Measures"
class Gallery {

  final String id;
  static const String type ='_Gallery';
  final DateTime date;
  String? frontal;
  String? perfil;
  String? espalda;
  String? piernas;

  Gallery({ required this.id, required this.date, this.frontal, this.espalda, this.perfil, this.piernas });

  Gallery.create({required this.date})
    : id = date.id+type,
     frontal = '',
     perfil = '',
     espalda = '',
     piernas = '';


  Gallery.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        date = map['date'].toDate(),
        frontal = map['frontal'],
        perfil  = map['perfil'],
        espalda = map['espalda'],
        piernas = map['piernas'];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'type' : type,
      'date' : date,
      'frontal' : frontal,
      'perfil' : perfil ,
    };
  }
}
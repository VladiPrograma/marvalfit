import 'package:cloud_firestore/cloud_firestore.dart';

enum CardioType {WALK, RUN, CICLING, SWIM, DANCE, OTHER}
enum CardioMeasure {CAL, MINS, STEPS, KM}
class Cardio {
  String id;
  DateTime date;
  CardioType type;
  CardioMeasure measure;
  int num;

  Cardio({
    required this.date,
    required this.type,
    required this.measure,
    required this.num})
    : id = Timestamp.now().microsecondsSinceEpoch.toString();

  Cardio.empty()
      : id = Timestamp.now().microsecondsSinceEpoch.toString(),
        num = 0,
        type = CardioType.WALK,
        measure = CardioMeasure.CAL,
        date = DateTime.now();

  Cardio.fromMap(Map<String, dynamic> map)
      :  num = map['num'],
        id = map['id'],
        type = CardioType.values.firstWhere((type) => type.name == map['type']),
        measure = CardioMeasure.values.firstWhere((type) => type.name == map['measure']),
        date = map['date'].toDate();

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'num': num,
      'type': type.name,
      'measure': measure.name,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Cardio{id: $id, date: $date, type: $type, measure: $measure, num: $num}';
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/planing.dart';
import '../../utils/objects/user_daily.dart';

Creator<DateTime> dateCreator = Creator((value){
  DateTime date = DateTime.now();
  createDaily(date);
  return date;
});
Creator<DateTime> weekCreator = Creator.value(DateTime.now().lastMonday());
Creator<String> activityCreator = Creator.value('init');

final dailyEmitter = Emitter.stream((ref) async {
  final date = ref.watch(dateCreator);
  return FirebaseFirestore.instance.collection('users/${authUser.uid}/daily').doc(date.id).snapshots();
});

Daily? getDaily (Ref ref){
  final query = ref.watch(dailyEmitter.asyncData).data;
  if(isNull(query)||isNull(query!.data())){ return null; }
  try {
    return Daily.fromJson(query.data()!);
  } catch(e) {
    logError(logErrorPrefix+'Daily.fromJson tryCatch'); return null;  }
}
Future<Planing> getPlaning() async{
  final query = await FirebaseFirestore.instance.collection('trainings').doc(authUser.uid).get();
  return Planing.fromJson(query.data()!);
}
void createDaily(DateTime date) async{
  bool exists = await Daily.existsInDB(date);
  if(!exists){
    Planing planing = await getPlaning();
    Daily.create(date: date, habitsFromPlaning: planing.habits ?? [], activities: planing.activities ?? [])
        .setInDB();
  }
}
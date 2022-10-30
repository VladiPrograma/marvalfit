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
  createDailyIfDoNotExists(date);
  return date;
});
Creator<DateTime> weekCreator = Creator.value(DateTime.now().lastMonday());
Creator<String> activityCreator = Creator.value('init');
Creator<Daily?> dailyCreator = Creator.value(null);


final dailyEmitter = Emitter.stream((ref)  {
  final date = ref.watch(dateCreator);
  return FirebaseFirestore.instance.collection('users/${authUser.uid}/daily').doc(date.id).snapshots();
});

Daily? getDaily (Ref ref){
  final query = ref.watch(dailyEmitter.asyncData).data;
  if(isNull(query)||isNull(query!.data())){ return null; }

  try {
    return Daily.fromJson(query.data()!);
  } catch(e) {
    logError('$logErrorPrefix Error parsing Daily JSON'); return null;  }
}

void createDailyIfDoNotExists(DateTime date) async{
  bool exists = await Daily.existsInDB(date);
  if(!exists){
    Planing planing = await Planing.getFromBD(date);
    Daily.create(date: date, habitsFromPlaning: planing.habits ?? [], activities: planing.activities ?? [])
    .setInDB();
  }
}
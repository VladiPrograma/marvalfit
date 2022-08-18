import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';

import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';

Creator<String> journalCreator = Creator.value('List');

final dailyEmitter = Emitter.stream((ref) async {
  return  FirebaseFirestore.instance.collection('users/${authUser.uid}/daily')
      .orderBy('date', descending: true).limit(ref.watch(page)).snapshots();
}, keepAlive: true);
final page = Creator.value(3);
void  fetchMoreDays(Ref ref,{int? add}) => ref.update<int>(page, (n) => n + (add ?? 3));
void  fetchOneMonth(Ref ref) => ref.update<int>(page, (n){
  int day = DateTime.now().day;
  if(n<day) return day;
  return n;
});

List<Daily>? getLoadDailys(Ref ref){
  final query = ref.watch(dailyEmitter.asyncData).data;
  if(isNull(query)||query!.size==0){ return null; }
  //Pass data from querySnapshot to Messages
  final List<Daily> list = _queryToData(query);

  return list;
}

///* Internal Logic ///
List<Daily> _queryToData(QuerySnapshot<Map<String, dynamic>> query){
  List<Daily> list = [];
  for (var element in [...query.docs]){
    list.add(Daily.fromJson(element.data()));
  }
  return list;
}
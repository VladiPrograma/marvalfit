import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';

import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/message.dart';
import '../../utils/objects/user.dart';

final trainerCreator = Emitter.stream((ref) async {
  return  FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: 'marval@gmail.com').snapshots();
});

MarvalUser? getTrainerUser(Ref ref){
  final query = ref.watch(trainerCreator.asyncData).data;
  if(isNull(query)||query!.size==0){
    return null;
  }
  final map = query.docs.first.data();
  return  MarvalUser.fromJson(map);
}

final _page = Creator.value(1);
void fetchMoreMessages(Ref ref) => ref.update<int>(_page, (n) => n + 1);

List<Message>? getLoadMessages(Ref ref){
  final query = ref.watch(_chatCreator.asyncData).data;
  if(isNull(query)||query!.size==0){ return null; }
  //Pass data from querySnapshot to Messages
  final List<Message> list = _queryToData(query);

  return list;
}
Creator<int> notifyCreator = Creator.value(0);

Emitter<int> notifications = Emitter((ref, emit){
    final List<Message>? list = getLoadMessages(ref);
    logError('Charging data again');
    final notif = list?.where((element) => element.user!=authUser.uid && !element.read).length ?? 0;
    ref.update(notifyCreator, (p0) => notif);
}, keepAlive: true);


void readMessages(List<Message> data){
  data.where((element) => element.user!=authUser.uid && !element.read)
  .forEach((element) { element.updateRead(); });
}

///* Internal Logic ///
List<Message> _queryToData(QuerySnapshot<Map<String, dynamic>> query){
  List<Message> list = [];
  for (var element in [...query.docs]){
    list.add(Message.fromJson(element.data()));
  }
  return list;
}

final _chatCreator = Emitter.stream((ref) async {
  final authId = await ref.watch(
      authEmitter.where((auth) => auth!=null).map((auth) => auth!.uid));
  return FirebaseFirestore.instance.collection('users/$authId/chat')
      .orderBy('date',descending: true)
      .limit(10*ref.watch(_page))
      .snapshots();
}, keepAlive: true);


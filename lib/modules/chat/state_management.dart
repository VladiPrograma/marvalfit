


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/modules/chat/chat_screen.dart';

import '../../config/log_msg.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/message.dart';

final chatCreator = Emitter.stream((ref) async {
  /// This piece of code waits and only returns when AuthEmitter has UID data avalaible.
  final authId = await ref.watch(
      authEmitter.where((auth) => auth!=null).map((auth) => auth!.uid));
  return FirebaseFirestore.instance.collection('users/$authId/chat').orderBy('date',descending: true).limit(5).snapshots();
});
List<Message>? initialChatData(Ref ref){
  final query = ref.watch(chatCreator.asyncData).data;
  if(isNull(query)||query!.size==0){ return null; }
  List<Message> list = [];
  for (var element in [...query.docs]){
    list.add(Message.fromJson(element.data()));
  }
  return list;
}

///* -_-_-_- NEW UPDATES -_-_-_-
final lastTimestampCreator = Creator.value(DateTime.now());
void  updateTimestamp(Ref ref, DateTime date) => ref.update(lastTimestampCreator, (d) => date);

final firstTimestampCreator = Creator.value(DateTime.now());
void  updateFirstTimestamp(Ref ref, DateTime date) => ref.update(firstTimestampCreator, (d) => date);

List<Message> messages = <Message>[];
final chat = Creator.value(messages);

List<Message> getChatMessages(Ref ref)=> ref.watch(chat);
void addMessage(Ref ref, Message msg) => ref.update<List<Message>>(chat , (n)=> [msg, ...n]);
void loadMessages(Ref ref, List<Message> msgs) =>ref.update<List<Message>>(chat , (n)=> [...n, ...msgs]);

final chatEmitter = Emitter.stream((ref) async {
  final authId = await ref.watch(
      authEmitter.where((auth) => auth!=null).map((auth) => auth!.uid));
  return  FirebaseFirestore.instance.collection('users/$authId/chat')
      .where(  'date', isGreaterThan: ref.watch(firstTimestampCreator))
      .where(  'user', isNotEqualTo : authId)
      .orderBy('date', descending   : true)
      .limit(10).snapshots();
});

final fromUserEmitter = Emitter.stream((ref) async {
  final authId = await ref.watch(
      authEmitter.where((auth) => auth!=null).map((auth) => auth!.uid));
  return  FirebaseFirestore.instance.collection('users/$authId/chat')
      .where('date', isGreaterThan: ref.watch(lastTimestampCreator))
      .orderBy('date',descending: true)
      .limit(10).snapshots();
});

Future<void> fetchMessage(Ref ref) async{
  final query = ref.watch(chatEmitter.asyncData).data;
  if(isNull(query)||query!.size==0){ return; }
  List<Message> list = [];
  for (var element in [...query.docs]){
    list.add(Message.fromJson(element.data()));
  }
  logError('wait khe');
  updateTimestamp(ref, list.last.date);
  loadMessages(ref, list);
}
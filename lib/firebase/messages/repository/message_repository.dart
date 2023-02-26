import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';


CollectionReference _db = FirebaseFirestore.instance.collection('chat');
Creator<int> _cont = Creator.value(10);

final _unreadStream = Emitter<QuerySnapshot>((ref, emit) async{
  final authId = await ref.watch(
      authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));

  final cancel = (_db
      .where('user', isEqualTo: authId)
      .where('trainer', isEqualTo: true)
      .where('read', isEqualTo: false)
      .snapshots()
      .listen((event) => emit(event))
     ).cancel;
    ref.onClean(cancel);
  });

final _chatStream = Emitter<QuerySnapshot>((ref, emit) async{
  final authId = await ref.watch(
      authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));

  final cancel = (_db.where('user', isEqualTo: authId).
                      orderBy('date', descending: true).
                      limit(ref.watch(_cont)).snapshots().
                      listen((event) => emit(event))
  ).cancel;
  ref.onClean(cancel);
});



class MessageRepository{

  void fetchMore(Ref ref, {int? n}) => ref.update<int>(_cont, (current) => current + (n ?? 10));
  void fetchReset(Ref ref) => ref.update<int>(_cont, (current) => 10);

  List<Message> getChat(Ref ref){
    var query = ref.watch(_chatStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    return query?.docs.map((e) => Message.fromMap(e.data())).toList() ?? [];
  }
  List<Message> getUnread(Ref ref){
    var query = ref.watch(_unreadStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    return query?.docs.map((e) => Message.fromMap(e.data())).toList() ?? [];
  }

  Future<void> add(Ref ref, Message message) async{
    _db.doc(message.id).set(message.toMap());
  }
  Future<void> update(String id,  Map<String, dynamic> map) async{
    _db.doc(id).update(map);
  }
  Future<void> remove(Ref ref, String id) async{
    _db.doc(id).delete();
  }

}
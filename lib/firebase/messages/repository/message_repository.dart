import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';


CollectionReference _db = FirebaseFirestore.instance.collection('chat');
Creator<int> _cont = Creator.value(10);

Emitter _unreadStream = Emitter.stream((ref) => _db.where('read', isEqualTo: false).where('trainer', isEqualTo: false).orderBy('date').snapshots(), keepAlive: true);
final _chatStream = Emitter.arg1<QuerySnapshot, String>((ref, userId, emit) async{
  final cancel = (_db.where('user', isEqualTo: userId).
                      orderBy('date', descending: true).
                      limit(ref.watch(_cont)).snapshots().
                      listen((event) => emit(event))
  ).cancel;
  ref.onClean(cancel);
});



class MessageRepository{

  void fetchMore(Ref ref, {int? n}) => ref.update<int>(_cont, (current) => current + (n ?? 10));
  void fetchReset(Ref ref) => ref.update<int>(_cont, (current) => 10);

  List<Message> getChat(Ref ref, String userId){
    var query = ref.watch(_chatStream(userId).asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
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
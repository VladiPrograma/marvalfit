import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';

Creator<int> _page = Creator.value(1);
Creator<bool> _hasMore = Creator.value(true);

final _measureStream = Emitter.arg1<QuerySnapshot, String>((ref, userId, emit) async{
  final CollectionReference db = await ref.watch(_db);
  final cancel = (db.where('type', isEqualTo: ActivityType.MEASURES.name).
     orderBy('date', descending: true).
     limit(ref.watch(_page)).snapshots().
     listen((event) => emit(event))
     ).cancel;
  ref.onClean(cancel);
});

final Emitter<CollectionReference> _db = Emitter((ref, emit) async{
  final authId = await ref.watch(
      authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));
  emit(FirebaseFirestore.instance.collection('users/$authId/activities/'));
});

class MeasuresRepo{
  void fetchMore(Ref ref, int size){
    if(hasMore(ref)){
      ref.update<int>(_page, (current) => current + 1 );
    }
  }
  // Add an exact number to the fetch cont
  void fetch(Ref ref, int n) => ref.update<int>(_page, (current) => current + n);
  int getSize(Ref ref) => ref.watch(_page);
  void ifHasMore(Ref ref, int size){
    int cont = getSize(ref);
    cont<=size ? more(ref) : noMore(ref);
  }

  bool hasMore(Ref ref) => ref.watch(_hasMore);
  void  noMore(Ref ref) => ref.update(_hasMore, (p0) => false);
  void  more(Ref ref) => ref.update(_hasMore, (p0) => true);

  List<Measures> get(Ref ref, String userId){
    var query = ref.watch(_measureStream(userId).asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    final res = query?.docs.map((e) => Measures.fromMap(e.data())).toList() ?? [];
    ifHasMore(ref, res.length);
    return res;
  }
  Future<void> add(Ref ref, Measures measure) async{
    CollectionReference db = await ref.watch(_db);
    db.doc(measure.id).set(measure.toMap());
  }

  Future<Measures?> getById(Ref ref, String id) async{
    final db = FirebaseFirestore.instance.collection('users/$uid/activities');
    final query = await db.doc(id).get();
    if(query.data() != null){
      return Measures.fromMap(query.data()!);
    }
    return null;
  }

  Future<void> update(String userId, String measureId, Map<String, dynamic> map) =>
      FirebaseFirestore.instance.collection("users/$userId/activities").doc(measureId).update(map);

  Future<void> remove(String userId, String measureId) =>
      FirebaseFirestore.instance.collection("users/$userId/activities").doc(measureId).delete();
}




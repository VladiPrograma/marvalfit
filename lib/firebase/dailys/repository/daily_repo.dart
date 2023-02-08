import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/utils/extensions.dart';
import '../model/daily.dart';

Creator<int> _page = Creator.value(3);
Creator<bool> _hasMore = Creator.value(true);

final Emitter<CollectionReference> _db = Emitter((ref, emit) async{
  final authId = await ref.watch(
      authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));
  emit(FirebaseFirestore.instance.collection('users/$authId/daily'));
});

final _oneDailyStream = Emitter.arg1<QuerySnapshot, String>((ref, id, emit) async{
  final CollectionReference db = await ref.watch(_db);
  final cancel = (db.where('id', isEqualTo: id).
  limit(1).snapshots().
  listen((event) => emit(event))
  ).cancel;
  ref.onClean(cancel);
});

final _dailyStream = Emitter<QuerySnapshot>((ref, emit) async{
  final CollectionReference db = await ref.watch(_db);
  final cancel = (db.orderBy('date', descending: true).
  limit(ref.watch(_page)).snapshots().
  listen((event) => emit(event))
  ).cancel;
  ref.onClean(cancel);
});

final _dailyDoc = Emitter.arg1<Daily?, DateTime>((ref, date, emit) async{
  final CollectionReference db = await ref.watch(_db);
  final doc = await db.doc(date.id).get();
  if(doc.exists){
    emit(Daily.fromMap(doc.data() as Map<String, dynamic>));
  }else{
    emit(null);
  }

});

class DailyRepo{
   void fetchMore(Ref ref, int size){
     if(hasMore(ref)){
       ref.update<int>(_page, (current) => current + 3 );
     }
   }

   List<Daily> get(Ref ref){
     var query = ref.watch(_dailyStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
     final res = query?.docs.map((e) => Daily.fromMap(e.data())).toList() ?? [];
     ifHasMore(ref, res.length);
     return res;
   }

   Future<Daily?> getByDate(DateTime date) async{
     if(uid!= null){
       final db = FirebaseFirestore.instance.collection('users/$uid/daily');
       final query = await db.doc(date.id).get();
       if(query.data() != null){
         return Daily.fromMap(query.data()!);
       }
     }
     return null;
   }


   Future<void> add(Ref ref, Daily daily) async {
     final CollectionReference db = await ref.watch(_db);
     db.doc(daily.id).set(daily.toMap());
   }

   Future<void> update(Ref ref, DateTime date, Map<String, dynamic> map) async {
     final CollectionReference db = await ref.watch(_db);
     db.doc(date.id).update(map);
   }

   Future<void> remove(Ref ref, Daily daily) async {
     final CollectionReference db = await ref.watch(_db);
     db.doc(daily.id).delete();
   }

   // Fetch Logic
   void fetch(Ref ref, int n) => ref.update<int>(_page, (current) => current + n);

   int getSize(Ref ref) => ref.watch(_page);

   void ifHasMore(Ref ref, int size){
     int cont = getSize(ref);
     cont<=size ? more(ref) : noMore(ref);
   }

   bool hasMore(Ref ref) => ref.watch(_hasMore);
   void  noMore(Ref ref) => ref.update(_hasMore, (p0) => false);
   void  more(Ref ref) => ref.update(_hasMore, (p0) => true);
}




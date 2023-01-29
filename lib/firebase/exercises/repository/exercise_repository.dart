import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/firebase/exercises/model/exercise.dart';
import 'package:marvalfit/firebase/exercises/model/tags.dart';

final CollectionReference _db = FirebaseFirestore.instance.collection('exercises');
Creator<int> _page = Creator.value(8);
Creator<bool> _hasMore = Creator.value(true);

Emitter _exerciseStream = Emitter.stream((ref) async {
  return _db.orderBy('name').limit(ref.watch(_page)).snapshots();
}, keepAlive: true);
final _searchByName = Emitter.arg1<QuerySnapshot, String>((ref, name, emit) async{
  final cancel = (_db.where('keywords', arrayContains: name)
      .limit(ref.watch(_page))
      .snapshots().listen((event) => emit(event))).cancel;
  ref.onClean(cancel);
});
final _searchByTag = Emitter.arg1<QuerySnapshot, String>((ref, search, emit) async{
  final cancel = (_db.where('tags', arrayContainsAny: [search])
      .limit(ref.watch(_page))
      .snapshots().listen((event) => emit(event))).cancel;
  ref.onClean(cancel);
});

Emitter _tagStream = Emitter.stream((ref) async {
  return _db.doc('tags').snapshots();
}, keepAlive: true);

class ExerciseRepository{

  List<Exercise> get(Ref ref) {
    var query = ref.watch(_exerciseStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    final res = query?.docs.map((doc) => Exercise.fromMap(doc.data())).toList() ?? [];
    ifHasMore(ref, res.length);
    return res;
  }
  void fetchMore(Ref ref, int size){
    if(hasMore(ref)){
      ref.update<int>(_page, (current) => current + 3 );
    }
  }
  // Add an exact number to the fetch cont
  void fetch(Ref ref, int n) => ref.update<int>(_page, (current) => current + n);

  int getCont(Ref ref) => ref.watch(_page);
  void resetCont(Ref ref) => ref.update(_page, (p0) => 8);

  int getSize(Ref ref) => ref.watch(_page);
  void ifHasMore(Ref ref, int size){
    int cont = getSize(ref);
    cont<=size ? more(ref) : noMore(ref);
  }

  bool hasMore(Ref ref) => ref.watch(_hasMore);
  void  noMore(Ref ref) => ref.update(_hasMore, (p0) => false);
  void  more(Ref ref) => ref.update(_hasMore, (p0) => true);


  List<Exercise> getByName(Ref ref, String name){
    if(name.length<3) return get(ref);
    var query = ref.watch(_searchByName(name.substring(0,3).toLowerCase()).asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    final res = query?.docs.map((doc) => Exercise.fromMap(doc.data())).toList() ?? [];
    ifHasMore(ref, res.length);
    return res;
  }
  List<Exercise> getByTag(Ref ref, String search){
    if(search.isEmpty) return get(ref);
    var query = ref.watch(_searchByTag(search).asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    final res = query?.docs.map((doc) => Exercise.fromMap(doc.data())).toList() ?? [];
    ifHasMore(ref, res.length);
    return res;
  }


  Future<DocumentSnapshot> getDocument(String id) =>  _db.doc(id).get();
  Future<void> add(Exercise exercise) => _db.doc(exercise.id).set(exercise.toMap());
  Future<void> update(String id, Map<String, dynamic> map) =>  _db.doc(id).update(map);
  Future<void> delete(String id) => _db.doc(id).delete();


  Tags getTags(Ref ref) {
    DocumentSnapshot? query = ref.watch(_tagStream.asyncData).data;
    return query!=null ? Tags.fromMap(query.data() as Map<String, dynamic>) : Tags.empty();
  }
  Future<void> updateTags(Map<String, Object> map) => _db.doc('tags').update(map);
}
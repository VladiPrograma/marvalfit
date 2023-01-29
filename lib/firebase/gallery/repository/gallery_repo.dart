import 'package:creator/creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';

Creator<int> _page = Creator.value(3);
Creator<bool> _hasMore = Creator.value(true);

final _db = Emitter.arg1<CollectionReference, String>((ref, userId, emit) =>
  emit(FirebaseFirestore.instance.collection("users/$userId/activities")));
  final _galleryStream = Emitter.arg1<QuerySnapshot, String>((ref, userId, emit) async{
  final CollectionReference db = await ref.watch(_db(userId));
  final cancel = (db.where('type', isEqualTo: '_Gallery').
    orderBy('date', descending: true).
    limit(ref.watch(_page)).snapshots().
    listen((event) => emit(event))
  ).cancel;
  ref.onClean(cancel);
});

class GalleryRepo{

  void fetchMore(Ref ref, int size){
    if(hasMore(ref)){
      ref.update<int>(_page, (current) => current + 3 );
    }
  }
  void fetch(Ref ref, int n) => ref.update<int>(_page, (current) => current + n);

  int getSize(Ref ref) => ref.watch(_page);

  void ifHasMore(Ref ref, int size){
    int cont = getSize(ref);
    cont<=size ? more(ref) : noMore(ref);
  }

  bool hasMore(Ref ref) => ref.watch(_hasMore);
  void  noMore(Ref ref) => ref.update(_hasMore, (p0) => false);
  void  more(Ref ref) => ref.update(_hasMore, (p0) => true);


  List<Gallery> get(Ref ref, String userId){
    var query = ref.watch(_galleryStream(userId).asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    final res = query?.docs.map((e) => Gallery.fromMap(e.data())).toList() ?? [];
    ifHasMore(ref, res.length);
    return res;
  }

  Future<void> add(String userId, Gallery gallery) =>
      FirebaseFirestore.instance.collection('users/$userId/activities/').doc(gallery.id).set(gallery.toMap());
  Future<void> update(String userId, String galleryId, Map<String, dynamic> map) =>
      FirebaseFirestore.instance.collection('users/$userId/activities').doc(galleryId).update(map);
  Future<void> remove(String userId, String galleryId) =>
      FirebaseFirestore.instance.collection('users/$userId/activities').doc(galleryId).delete();
}




import 'package:creator/creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/firebase/habits/model/habits.dart';

final CollectionReference _db = FirebaseFirestore.instance.collection('habits');

Emitter _habitsStream = Emitter.stream((ref) async {
  return _db.orderBy('label').snapshots();
}, keepAlive: true);


class HabitsRepository{

  List<Habit> get(Ref ref) {
    var query = ref.watch(_habitsStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    return query?.docs.map((e) => Habit.fromMap(e.data())).toList() ?? [];
  }
  Future<DocumentSnapshot> getDocument(String name) =>  _db.doc(name).get();

  Future<void> add(Habit habit) => _db.doc(habit.id).set(habit.toMap());

  Future<void> update(String id, Map<String, Object> map) => _db.doc(id).update(map);

  Future<void> delete(String id) => _db.doc(id).delete();

}

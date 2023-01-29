import 'package:creator/creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';

final CollectionReference _db = FirebaseFirestore.instance.collection('workouts');

Emitter _trainingStream = Emitter.stream((ref) async {
  return _db.orderBy('name').snapshots();
}, keepAlive: true);



class TrainingRepository{
  List<Training> get(Ref ref) {
    var query = ref.watch(_trainingStream.asyncData).data as QuerySnapshot<Map<String, dynamic>>?;
    return query?.docs.map((e) => Training.fromMap(e.data())).toList() ?? [];
  }
  Future<DocumentSnapshot> getDocument(String name) =>  _db.doc(name).get();

  Future<void> add(Training training) => _db.doc(training.id).set(training.toMap());

  Future<void> update(String id, Map<String, Object> map) => _db.doc(id).update(map);

  Future<void> delete(String id) => _db.doc(id).delete();

}
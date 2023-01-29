import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:collection/collection.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';
import 'package:marvalfit/firebase/trainings/repository/training_repo.dart';

//@TODO pending to add DailyHabits.
class TrainingLogic{
  TrainingRepository repo = TrainingRepository();

  List<Training>? getAll( Ref ref) => repo.get(ref).toList();

  Training? getByID(String id, Ref ref) => getAll(ref)?.
  firstWhereOrNull((training) => training.id == id);

  Future<void> updateUser(Training training, String uid){
    return training.users.contains(uid) ?
    repo.update(training.id, {'users' : FieldValue.arrayRemove([uid])}) :
    repo.update(training.id, {'users' : FieldValue.arrayUnion( [uid])});
  }

  Future<void> add(Training training){
    training.startDate = DateTime.now();
    training.id = Timestamp.now().millisecondsSinceEpoch.toString();
    return repo.add(training);
  }

  Future<void> set(Training training){
    training.lastUpdate = DateTime.now();
    return repo.add(training);
  }

  Future<void> delete(String id) => repo.delete(id);

}
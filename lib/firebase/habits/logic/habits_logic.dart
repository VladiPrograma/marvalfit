import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:collection/collection.dart';
import 'package:marvalfit/firebase/habits/model/habits.dart';
import 'package:marvalfit/firebase/habits/repository/habits_repo.dart';

//@TODO pending to add DailyHabits.
class HabitsLogic{
  HabitsRepository repo = HabitsRepository();

  List<Habit>? getAll( Ref ref) => repo.get(ref).toList();

  Habit? getByID(String id, Ref ref) => getAll(ref)?.
  firstWhereOrNull((habit) => habit.id == id);

  Future<void> updateUser(Habit habit, String uid){
    return habit.users.contains(uid) ?
    repo.update(habit.id, {'users' : FieldValue.arrayRemove([uid])}) :
    repo.update(habit.id, {'users' : FieldValue.arrayUnion( [uid])});
  }

  Future<void> add(Habit training){
    training.startDate = DateTime.now();
    training.id = Timestamp.now().millisecondsSinceEpoch.toString();
    return repo.add(training);
  }

  Future<void> set(Habit habit){
    habit.lastUpdate = DateTime.now();
    return repo.add(habit);
  }

  Future<void> delete(String id) => repo.delete(id);

}

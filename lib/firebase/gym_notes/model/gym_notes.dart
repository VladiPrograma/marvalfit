import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marvalfit/firebase/gym_notes/model/workout_notes.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';
import 'package:marvalfit/utils/marval_arq.dart';

class GymNotes{
  String id;
  String training;
  DateTime date;
  List<WorkoutNote> workouts;


  GymNotes({required this.id, required this.training, required this.date, required this.workouts});

  GymNotes.fromTraining(Training item)
  :  id = '',
    training = item.id,
    date = DateTime.now(),
    workouts = item.workouts.map((e) => WorkoutNote.fromWorkout(e)).toList();

  GymNotes.empty():
        id = '',
        training = '',
        date = DateTime.now(),
        workouts = [];

  GymNotes.clone(GymNotes gymNote)
      :   id = gymNote.id,
        training = gymNote.training,
        date = gymNote.date,
        workouts = gymNote.workouts.toList();

  GymNotes.fromMap(Map<String, dynamic> map)
      :    id = map['id'],
        date = map['date'].toDate(),
        training = map['training'],
        workouts =  List<Map<String, dynamic>>.from(map["workouts"] ?? []).map((e) => WorkoutNote.fromMap(e)).toList();

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'training' : training,
      'date' : date,
      'workouts' : workouts.map((e) => e.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'GymNotes{id: $id, training: $training, date: $date, workouts: $workouts}';
  }

  @override
  bool operator ==(Object other) =>
      other is GymNotes &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          training == other.training &&
          date == other.date &&
          eq(workouts, other.workouts)  ;

  @override
  int get hashCode =>
      id.hashCode ^ training.hashCode ^ date.hashCode ^ workouts.hashCode;
}
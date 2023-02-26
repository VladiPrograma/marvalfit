import 'package:marvalfit/firebase/trainings/model/workout.dart';
import 'package:marvalfit/utils/marval_arq.dart';

class WorkoutNote {
  String exercise;
  List<int> reps;
  int weight;
  WorkoutType type;

  WorkoutNote({
    required this.exercise,
    required this.reps,
    required this.weight,
    required this.type

  });


  WorkoutNote.fromWorkout(  Workout workout)
      : exercise = workout.exercise,
        type = workout.type,
        reps = List.generate(workout.series, (index) => 0),
        weight = 0;

  WorkoutNote.fromMap(Map<String, dynamic> map)
      :
        exercise = map['exercise'],
        reps = List<int>.from(map["reps"]),
        weight = map['weight'],
        type = WorkoutType.values.byName(map["type"]);

  Map<String, dynamic> toMap(){
    return {
      'exercise' : exercise,
      'reps' : reps,
      'weight' : weight,
      'type' : type.name,
    };
  }

  @override
  String toString() {
    return 'WorkoutNote{exercise: $exercise, reps: $reps, weight: $weight, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      other is WorkoutNote && runtimeType == other.runtimeType &&
              exercise == other.exercise && eq(reps, other.reps) &&
              weight == other.weight && type == other.type;

  @override
  int get hashCode =>
      exercise.hashCode ^ reps.hashCode ^ weight.hashCode ^ type.hashCode;


}

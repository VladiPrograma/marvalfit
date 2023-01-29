enum WorkoutType {Normal, DropSet, BabyReps,}
class Workout {
  String name;
  String exercise;
  int maxReps;
  int minReps;
  int series;
  int rir;
  int restSeconds;
  WorkoutType type;

  Workout({
    required this.exercise,
    required this.name,
    required this.maxReps,
    required this.minReps,
    required this.series,
    required this.rir,
    required this.restSeconds,
    required this.type,
  });
  Workout.empty( {required this.exercise, required this.name})
      :
        maxReps = 15,
        minReps = 15,
        series = 3,
        rir = 2,
        restSeconds = 150,
        type = WorkoutType.values[0];

  Workout.fromMap(Map<String, dynamic> map)
      :
        name = map['name'],
        exercise = map['exercise'],
        maxReps = map['max_reps'],
        minReps = map['min_reps'],
        series = map['series'],
        rir = map['rir'],
        restSeconds = map['rest_seconds'],
        type = WorkoutType.values.byName(map["type"]);

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'exercise' : exercise,
      'max_reps' : maxReps,
      'min_reps' : minReps,
      'series' : series,
      'rir' : rir,
      'rest_seconds' : restSeconds,
      'type' : type.name,
    };
  }

  @override
  String toString() {
    return 'Workout{ name: $name, exercise: $exercise, maxReps: $maxReps, minReps: $minReps, series: $series, rir: $rir, rest: $restSeconds, type: $type}';
  }

  @override
  get hashCode => Object.hash(     name,      maxReps,      minReps,      series,      rir,      restSeconds,      type,    exercise  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Workout &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          exercise == other.exercise &&
          maxReps == other.maxReps &&
          minReps == other.minReps &&
          series == other.series &&
          rir == other.rir &&
          restSeconds == other.restSeconds &&
          type == other.type;
}

import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/cardio.dart';
import 'package:marvalfit/firebase/habits/dto/habits_resume.dart';

class Daily{
  String id;
  int sleep;
  int? steps;
  double weight;
  DateTime date;
  List<String> habits;
  List<HabitsResumeDTO> habitsFromPlaning;
  List<Activity> activities;
  List<Cardio> cardio;


  @override
  String toString() {
    return 'Daily{id: $id, sleep: $sleep, steps: $steps, weight: $weight, date: $date, habits: $habits, habitsFromPlaning: $habitsFromPlaning, activities: $activities, cardio: $cardio}';
  }

  Daily({
    required this.id,
    required this.date,
    required this.sleep,
    required this.weight,
    required this.habits,
    required this.habitsFromPlaning,
    required this.activities,
    required this.steps,
    required this.cardio,
  });

  Daily.empty():
        id = '',
        sleep = 0,
        steps = 0,
        weight = 0,
        date = DateTime.now(),
        habits = [],
        cardio = [],
        activities = [],
        habitsFromPlaning = [];

Daily.fromMap(Map<String, dynamic> map):
  id = map['id'],
  sleep = map['sleep'],
  steps = map['steps'],
  weight = map['weight'],
  date = map['date'].toDate(),
  habits = List<String>.from(map["habits"] ?? ""),
  habitsFromPlaning =  List<Map<String, dynamic>>.from(map["habits_from_planing"] ?? []).map((e) => HabitsResumeDTO.fromMap(e)).toList(),
  cardio =  List<Map<String, dynamic>>.from(map["cardio"] ?? []).map((e) => Cardio.fromMap(e)).toList(),
  activities =  List<Map<String, dynamic>>.from(map["activities"] ?? []).map((e) => Activity.fromMap(e)).toList();

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'sleep' : sleep,
      'steps' : steps,
      'weight' : weight,
      'date' : date,
      'habits' : habits,
      'habits_from_planing': habitsFromPlaning.map((e) => e.toMap()).toList(),
      'cardio': cardio.map((e) => e.toMap()).toList(),
      'activities': activities.map((e) => e.toMap()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
          other is Daily &&
          id == other.id &&
          sleep == other.sleep &&
          cardio == other.cardio &&
          steps == other.steps &&
          weight == other.weight &&
          date == other.date &&
          habits == other.habits &&
          activities == other.activities;

  @override
  int get hashCode =>
      id.hashCode ^
      sleep.hashCode ^
      steps.hashCode ^
      weight.hashCode ^
      date.hashCode ^
      cardio.hashCode ^
      habits.hashCode ^
      activities.hashCode;
}


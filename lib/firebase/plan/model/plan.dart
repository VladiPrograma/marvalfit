import 'package:marvalfit/firebase/habits/dto/habits_resume.dart';
import 'package:marvalfit/firebase/trainings/dto/TrainingResumeDTO.dart';

class Plan {

  String userId;
  DateTime startDate;
  int stepGoal;
  List<HabitsResumeDTO> habits;
  List<TrainingResumeDTO> trainings;

  Plan({
    required this.userId,
    required this.habits,
    required this.trainings,
    required this.startDate,
    required this.stepGoal,
  });

  @override
  String toString() {
    return 'Plan{userId: $userId, startDate: $startDate, stepGoal: $stepGoal, habits: ${habits.length}, trainings: $trainings}';
  }

  Plan.empty()
  :   userId = "",
      habits = [],
      trainings = [],
      stepGoal = 0,
      startDate = DateTime.now();


  Plan.fromMap(Map<String, dynamic> map)
      : userId = map["user_id"],
        stepGoal = map["step_goal"],
        startDate = map["start_date"].toDate(),
        habits =  List<Map<String, dynamic>>.from(map["habits"] ?? []).map((e) => HabitsResumeDTO.fromMap(e)).toList(),
        trainings =  List<Map<String, dynamic>>.from(map["trainings"] ?? []).map((e) => TrainingResumeDTO.fromMap(e)).toList();

  Map<String, dynamic> toMap(){
    return {
      'user_id': userId, // UID
      'step_goal': stepGoal, // Vlad
      'start_date': startDate, // Dumitru
      'habits': habits.map((e) => e.toMap()).toList(), // Dumitru
      'trainings': trainings.map((e) => e.toMap()).toList(),
    };
  }



}
import 'package:marvalfit/firebase/habits/model/habits.dart';

//@TODO remember that de String? id variable is nullable bc on the test dailys habits hasnt id.
class DailyHabitsDTO{
  String id;
  String name;
  String label;
  String description;

  DailyHabitsDTO({required this.id, required this.name, required this.label, required this.description});

  DailyHabitsDTO.fromUser(Habit habit):
        name = habit.name,
        id = habit.id,
        label = habit.label,
        description = habit.description;

  DailyHabitsDTO.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        description = map["description"],
        label = map["label"];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'label' : label,
    };
  }

  @override
  String toString(){
    return 'Habit: {id: $id, name: $name, label: $label, desc: $description } \n';
  }
}
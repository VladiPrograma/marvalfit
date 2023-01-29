

import 'package:marvalfit/firebase/habits/model/habits.dart';

class HabitsResumeDTO{
  String name;
  String label;
  String description;
  HabitsResumeDTO({ required this.label, required this.description, required this.name});

  HabitsResumeDTO.fromHabit(Habit habit):
   name = habit.name,
   description = habit.description,
   label = habit.label;

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'description' : description,
      'label' : label
    };
  }
  HabitsResumeDTO.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        description = map['description'],
        label = map['label'];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitsResumeDTO &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          label == other.label &&
          description == other.description;

  @override
  int get hashCode =>
      name.hashCode ^ label.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'HabitsResumeDTO{ label: $label, name: $name, description: $description}';
  }
}
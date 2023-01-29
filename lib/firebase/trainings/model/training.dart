import 'package:marvalfit/utils/marval_arq.dart';

import 'workout.dart';

class Training{
  String id;
  String name;
  String label;
  DateTime startDate;
  DateTime lastUpdate;
  List<String> users;
  List<Workout> workouts;

  Training({required this.id, required this.label, required this.name, required this.startDate, required this.users, required this.workouts, required this.lastUpdate});

  Training.empty():
      id = '',
      name = '',
      label = '',
      startDate = DateTime.now(),
      lastUpdate = DateTime.now(),
      users = [],
      workouts = [];

  Training.clone(Training training)
  :   id = training.id,
      name = training.name,
      label = training.label,
      startDate = training.startDate,
      lastUpdate = training.lastUpdate,
      users = training.users.toList(),
      workouts = training.workouts.toList();

  Training.fromMap(Map<String, dynamic> map)
   :    id = map['id'],
        name = map['name'],
        label = map['label'],
        startDate = map['start_date'].toDate(),
        lastUpdate = map['last_update'].toDate(),
        users = List<String>.from(map["users"]),
        workouts =  List<Map<String, dynamic>>.from(map["workouts"] ?? []).map((e) => Workout.fromMap(e)).toList();

   Map<String, dynamic> toMap(){
     return {
       'id' : id,
       'name' : name,
       'label' : label,
       'start_date' : startDate,
       'last_update' : lastUpdate,
       'users' : users,
       'workouts' : workouts.map((e) => e.toMap()).toList(),
     };
   }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Training &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          label == other.label &&
          startDate == other.startDate &&
          lastUpdate == other.lastUpdate &&
          eq(users, other.users) &&
          eq(workouts, other.workouts);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      label.hashCode ^
      startDate.hashCode ^
      lastUpdate.hashCode ^
      users.hashCode ^
      workouts.hashCode;

  @override
  String toString() {
    return 'Training{id: $id, name: $name, label: $label startDate: $startDate, lastUpdate: $lastUpdate, users: $users, workouts: $workouts}';
  }

}
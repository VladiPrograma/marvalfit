
import 'package:marvalfit/utils/marval_arq.dart';

class Habit {
  String id;
  String name;
  String label;
  String description;
  DateTime startDate;
  DateTime lastUpdate;
  List<String> users;

  Habit.clone(Habit habit)
  : id = habit.id,
    name = habit.name,
    label = habit.label,
    description = habit.description,
    startDate = habit.startDate,
    lastUpdate = habit.lastUpdate,
    users = habit.users.toList();

  Habit({
    required this.id,
    required this.name,
    required this.label,
    required this.description,
    required this.users,
    required this.startDate,
    required this.lastUpdate,
  });
  Habit.empty()
  :     id = '',
        name = '',
        description = '',
        label = '',
        users = [],
        startDate = DateTime.now(),
        lastUpdate = DateTime.now();

  Habit.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        description = map["description"],
        label = map["label"],
        users = List<String>.from(map["users"]),
        lastUpdate = map["last_update"].toDate(),
        startDate = map["start_date"].toDate();

  Map<String, dynamic> toMap(){
    return {
      'id': id, // Vlad
      'name': name, // Vlad
      'label': label, // Dumitru
      'description': description, // Dumitru
      'users': users, // Dumitru
      'start_date': startDate,
      'last_update': lastUpdate,
      'keywords' : getKeywords(name.toLowerCase())
    };
  }
  @override
  String toString() {
    return 'Habit{id: $id, name: $name, label: $label, description: $description, startDate: $startDate, lastUpdate: $lastUpdate, users: $users}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          label == other.label &&
          description == other.description &&
          startDate == other.startDate &&
          lastUpdate == other.lastUpdate &&
          eq(users, other.users);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      label.hashCode ^
      description.hashCode ^
      startDate.hashCode ^
      lastUpdate.hashCode ^
      users.hashCode;
}
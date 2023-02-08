import 'package:marvalfit/firebase/trainings/dto/TrainingResumeDTO.dart';

enum ActivityType  {REST, CARDIO, MEASURES, GALLERY, GYM, EMPTY}

class Activity{
  String id;
  bool completed;
  String reference;
  String icon;
  String label;
  ActivityType type;

  Activity({required this.id, required this.icon, required this.label, required this.type, required this.completed, required this.reference});

  Activity.empty()
      : id ="",
        completed =  false,
        reference =  "",
        icon = "",
        label = "",
        type = ActivityType.EMPTY;

  Activity.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        completed = map["completed"] ?? false,
        reference = map["reference"] ?? "",
        icon = map["icon"] ?? "",
        label = map["label"] ?? "",
        type = ActivityType.values.byName( map["type"]);

  Activity.fromTraining(TrainingResumeDTO training)
      : id = training.id,
        completed = false,
        reference = '',
        icon = '',
        label = training.label,
        type = ActivityType.GYM;

  Activity.rest()
      : id = 'rest',
        completed = false,
        reference = '',
        icon = 'rest',
        label = 'Descanso',
        type = ActivityType.REST;

  Activity.measures()
      : id = 'measures',
        completed = false,
        reference = '',
        icon = 'measures',
        label = 'Medidas',
        type = ActivityType.MEASURES;

  Activity.gallery()
      : id = 'gallery',
        completed = false,
        reference = '',
        icon = 'gallery',
        label = 'Galeria',
        type = ActivityType.GALLERY;

  //TODO Montar una pantalla tipo "Cardio" donde escoges la actividad fisica y el tiempo y/o calorias.
  Activity.cardio()
      : id = 'cardio',
        completed = false,
        reference = '',
        icon = 'cardio',
        label = 'Cardio',
        type = ActivityType.CARDIO;

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'completed': completed,
      'reference': reference,
      'icon' : icon,
      'label': label,
      'type': type.name,
    };
  }

  void clone(Activity activity){
    id = activity.id;
    completed =activity.completed;
    reference = activity.reference;
    icon =activity.icon;
    label = activity.label;
    type = activity.type;
  }

  @override
  String toString(){
    return 'Habit: $id [ completed: $completed, reference $reference, icon: $icon , label: $label, type $type]';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Activity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              completed == other.completed &&
              reference == other.reference &&
              icon == other.icon &&
              label == other.label &&
              type == other.type;

  @override
  int get hashCode =>
      id.hashCode ^
      completed.hashCode ^
      reference.hashCode ^
      icon.hashCode ^
      label.hashCode ^
      type.hashCode;
}


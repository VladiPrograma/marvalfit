import 'package:marvalfit/firebase/trainings/model/training.dart';

class TrainingResumeDTO{
  String id;
  String label;
  TrainingResumeDTO({required this.id, required this.label});

  TrainingResumeDTO.fromTraining(Training training):
        id = training.id,
        label = training.label;

  TrainingResumeDTO.fromMap(Map<String, dynamic> map)
      :     id = map['id'],
            label = map['label'];

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'label' : label
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrainingResumeDTO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label;

  @override
  int get hashCode => id.hashCode ^ label.hashCode;

  @override
  String toString() {
    return 'TrainingResumeDTO{id: $id, label: $label}';
  }
}
import 'package:marvalfit/firebase/exercises/model/exercise.dart';
import 'package:marvalfit/firebase/habits/model/habits.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';

class ScreenArguments {
  final String? userId;
  final Exercise? exercise;
  final Training? training;
  final Habit? habit;
  ScreenArguments({this.userId, this.exercise, this.training, this.habit});
}
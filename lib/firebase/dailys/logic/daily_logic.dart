
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/repository/daily_repo.dart';
import 'package:marvalfit/firebase/plan/model/plan.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../model/daily.dart';

class DailyLogic{
  final DailyRepo _repo = DailyRepo();
  bool hasMore(Ref ref) => _repo.hasMore(ref);
  
  List<Daily> get(Ref ref, String userId) => _repo.get(ref);

  Future<Daily?> getByDate(DateTime date) async => await _repo.getByDate( date);


  Future<Daily> add(Ref ref, DateTime date, double lastWeight) async{
    Plan plan = await planLogic.getByDate( date) ?? Plan.empty();
    List<Activity> activities = [ Activity.rest(), Activity.measures(), Activity.gallery(), Activity.cardio()];
    activities.addAll(plan.trainings.map((e) => Activity.fromTraining(e)).toList());

    Daily daily = Daily(
        id: date.id,
        date: date,
        sleep: 0,
        weight: lastWeight,
        habits: [],
        cardio: [],
        habitsFromPlaning: plan.habits,
        activities: activities,
        steps: plan.stepGoal
    );
     _repo.add(ref, daily);
     return daily;
    }
  Future<void> update(Ref ref, DateTime date, Map<String, dynamic> map) => _repo.update(ref,  date, map);


  Future<void> remove(Ref ref,  Daily daily) => _repo.remove(ref,  daily);

  void fetchMore(Ref ref, int limit) => _repo.fetchMore(ref, limit);

  void fetch(Ref ref, int n) => _repo.fetch(ref, n);

}

import 'package:marvalfit/firebase/plan/model/plan.dart';
import 'package:marvalfit/firebase/plan/repository/plan_repo.dart';


class PlanLogic{
  final PlanRepository _planRepo = PlanRepository();

  Future<Plan?> getByDate( DateTime date) async => await _planRepo.getByDate(date);
}
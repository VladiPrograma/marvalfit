import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/habits/dto/habits_resume.dart';
import 'package:marvalfit/firebase/plan/model/plan.dart';
import 'package:marvalfit/firebase/trainings/dto/TrainingResumeDTO.dart';
import 'package:marvalfit/utils/marval_arq.dart';

 final CollectionReference _db = FirebaseFirestore.instance.collection('plan');
//
// final _planEmitter = Emitter.arg1<QuerySnapshot, DateTime>((ref, date, emit) async{
//   final userId = await ref.watch(
//       authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));
//   final cancel = ( _db.where('user_id', isEqualTo: userId)
//       .orderBy('start_date', descending: true).
//       limit(1).snapshots().
//       listen((event) => emit(event))
//   ).cancel;
//   ref.onClean(cancel);
// }, keepAlive: true);

class PlanRepository{

  Future<Plan?> getByDate(DateTime date) async {
    date = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final query = await _db
        .where('user_id', isEqualTo: uid)
        .orderBy('start_date', descending: true)
        .limit(1)
        .get();
    if(isNotNullOrEmpty(query.docs)){
      final map = query.docs.first.data() as Map<String, dynamic>;
      return Plan.fromMap(map);
    }
    return null;
  }
}
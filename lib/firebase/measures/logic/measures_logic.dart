import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';
import 'package:marvalfit/firebase/measures/repository/measures_repo.dart';
import 'package:marvalfit/utils/extensions.dart';


class MeasuresLogic{
  final MeasuresRepo _repo = MeasuresRepo();

  bool hasMore(Ref ref) => _repo.hasMore(ref);

  Future<void> add(Ref ref, Measures measure) {
    measure.id = '${measure.date.id}_${ActivityType.MEASURES.name}';
    return _repo.add(ref, measure);
  }

  Future<Measures?> getById(Ref ref, String id) => _repo.getById(ref, id);

  Measures? getLast(Ref ref, String userId){
    List<Measures> list = _repo.get(ref, userId);
    return list.isNotEmpty ? list[0] : null;
  }
  List<Measures> getList(Ref ref, String userId) => _repo.get(ref, userId);
  void fetchMore(Ref ref, int limit) => _repo.fetchMore(ref, limit);
  void fetch(Ref ref, int n) => _repo.fetch(ref, n);
}
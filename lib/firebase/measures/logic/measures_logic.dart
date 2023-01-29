import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';
import 'package:marvalfit/firebase/measures/repository/measures_repo.dart';


class MeasuresLogic{
  MeasuresRepo repo = MeasuresRepo();

  bool hasMore(Ref ref) => repo.hasMore(ref);

  Measures? getLast(Ref ref, String userId){
    List<Measures> list = repo.get(ref, userId);
    return list.isNotEmpty ? list[0] : null;
  }
  List<Measures> getList(Ref ref, String userId) => repo.get(ref, userId);
  void fetchMore(Ref ref, int limit) => repo.fetchMore(ref, limit);

  void fetch(Ref ref, int n) => repo.fetch(ref, n);
}
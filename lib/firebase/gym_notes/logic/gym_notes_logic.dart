import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/gym_notes/model/gym_notes.dart';
import 'package:marvalfit/firebase/gym_notes/repository/gym_notes_repository.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';
import 'package:marvalfit/firebase/measures/repository/measures_repo.dart';
import 'package:marvalfit/utils/extensions.dart';


class GymNotesLogic{
  final GymNotesRepo _repo = GymNotesRepo();

  bool hasMore(Ref ref) => _repo.hasMore(ref);

  Future<void> add(Ref ref, GymNotes gymNotes) {
    gymNotes.id = '${gymNotes.date.id}_${gymNotes.training}';
    return _repo.add(ref, gymNotes);
  }

  Future<GymNotes?> getById(Ref ref, String id) => _repo.getById(ref, id);

  GymNotes? getLast(Ref ref, String userId, String trainingId){
    List<GymNotes> list = _repo.get(ref, userId, trainingId);
    return list.isNotEmpty ? list[0] : null;
  }
  List<GymNotes> getList(Ref ref, String userId, String trainingId) => _repo.get(ref, userId, trainingId);
  void fetchMore(Ref ref, int limit) => _repo.fetchMore(ref, limit);
  void fetch(Ref ref, int n) => _repo.fetch(ref, n);
}
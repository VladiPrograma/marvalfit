import 'package:creator/creator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:marvalfit/firebase/exercises/model/exercise.dart';
import 'package:marvalfit/firebase/exercises/model/tags.dart';
import 'package:marvalfit/firebase/exercises/repository/exercise_repository.dart';
import 'package:marvalfit/utils/marval_arq.dart';

const int max_load_capacity = 5000;
class ExerciseLogic{
  final ExerciseRepository _repo = ExerciseRepository();

  bool hasMore(Ref ref) => _repo.hasMore(ref);

  void fetchMore(Ref ref, int limit) => _repo.fetchMore(ref, limit);
  void fetch(Ref ref, int n) => _repo.fetch(ref, n);
  void fetchReset(Ref ref) => _repo.resetCont(ref);

  List<Exercise> get( Ref ref) => _repo.get(ref).toList();
  List<Exercise> getByName(Ref ref, String search) => _repo.getByName(ref, search);
  List<Exercise> getByTag(Ref ref, String search) => _repo.getByTag(ref, search);
  
  List<Exercise> getByAllTags(Ref ref, List<String> tags){
      List<Exercise> res = getByTag(ref, tags.first);
      if(res.isEmpty) return _repo.get(ref);
            
      if(tags.length>1){
        Tags myTags = _repo.getTags(ref);
        if(myTags.values.contains(tags[1])){
          if(_repo.getCont(ref) < max_load_capacity){
            _repo.fetch(ref, max_load_capacity);
            _repo.noMore(ref);
          }
          res = res.where((exercise) => containsArray(exercise.tags, tags)).toList();
          return res.isEmpty ? getByAllTags(ref, tags.sublist(0, tags.length-1)) : res;    
        }
      }    
      return res;
  }
  Exercise? getByID(String id, Ref ref) => get(ref).firstWhereOrNull((exercise) => exercise.id == id);


  Future<void> updateTag(Exercise exercise, String tag){
    return exercise.tags.contains(tag) ?
    _repo.update(exercise.id, {'tags' : FieldValue.arrayRemove([tag])}) :
    _repo.update(exercise.id, {'tags' : FieldValue.arrayUnion( [tag])});
  }
  Future<void> update(Exercise exercise){
    return _repo.update(exercise.id, exercise.toMap());
  }
  Future<void> add(Exercise exercise) => _repo.add(exercise);
  Future<void> delete(String id) => _repo.delete(id);

  Tags? getTags(Ref ref) => _repo.getTags(ref);
  Future<void> addTag(String tag) =>  _repo.updateTags({'values' : FieldValue.arrayUnion([tag.capitalize()])});
  Future<void> removeTag(String tag) =>  _repo.updateTags({'values' : FieldValue.arrayRemove([tag])});

}
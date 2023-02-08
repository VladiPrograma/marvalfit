import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';
import 'package:marvalfit/firebase/gallery/repository/gallery_repo.dart';
import 'package:marvalfit/utils/extensions.dart';


class GalleryLogic{
  final GalleryRepo _repo = GalleryRepo();

  void fetchMore(Ref ref, int limit) => _repo.fetchMore(ref, limit);
  void fetch(Ref ref, int n) => _repo.fetch(ref, n);

  bool hasMore(Ref ref) => _repo.hasMore(ref);
  List<Gallery> get(Ref ref, String userId) => _repo.get(ref,userId);

  Future<void> add(Ref ref, Gallery gallery) {
    gallery.id = '${gallery.date.id}_${ActivityType.GALLERY.name}';
    return _repo.add(ref, gallery);
  }
  Future<Gallery?> getById(Ref ref, String id) => _repo.getById(ref, id);

  Gallery? getLast(Ref ref, String userId){
    List<Gallery> list = get(ref, userId);
    return list.isNotEmpty ? list[0] : null;
  }

}
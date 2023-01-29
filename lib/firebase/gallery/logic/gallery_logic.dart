import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';
import 'package:marvalfit/firebase/gallery/repository/gallery_repo.dart';


class GalleryLogic{
  GalleryRepo repo = GalleryRepo();

  void fetchMore(Ref ref, int limit) => repo.fetchMore(ref, limit);
  void fetch(Ref ref, int n) => repo.fetch(ref, n);

  bool hasMore(Ref ref) => repo.hasMore(ref);
  List<Gallery> get(Ref ref, String userId) => repo.get(ref,userId);

  Gallery? getLast(Ref ref, String userId){
    List<Gallery> list = get(ref, userId);
    return list.isNotEmpty ? list[0] : null;
  }

}
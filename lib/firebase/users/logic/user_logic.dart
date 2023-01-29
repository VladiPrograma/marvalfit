import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:marvalfit/firebase/users/repository/user_repo.dart';


class UserLogic{
  UserRepository userRepo = UserRepository();


  User? get(Ref ref) => userRepo.get(ref);
  Future<User?> getById() => userRepo.getById();
  Future<void> add(User user) => userRepo.add(user);

  Future<void> updateImage(Ref ref, String image) => userRepo.update(ref, {'profile_image' : image});
  Future<void> updateEmail(Ref ref, String email) => userRepo.update(ref, {'email' : email});
  Future<void> updateActive(Ref ref, bool active)  => userRepo.update(ref, {'active' : active});

  Future<void> updateWeight(Ref ref,double lastWeight, double newWeight)  =>
      userRepo.update( ref,
      {
        'new_weight' : newWeight,
        'last_weight' : lastWeight
      });


}
import '../model/user.dart';

class UserActiveDTO{
  String id;
  bool active;
  String? img;
  String name;
  String lastName;
  String job;
  String hobbie;
  UserActiveDTO({required this.id, required this.active, required this.name, required this.lastName, required this.job, required this.hobbie, this.img});
  UserActiveDTO.fromUser(User user):
        id = user.id,
        img = user.profileImage,
        active = user.active,
        name = user.name,
        lastName = user.lastName,
        hobbie = user.hobbie,
        job = user.work;

  @override
  String toString() {
    return 'UserActiveDTO{id: $id, active: $active, name: $name, lastName: $lastName, job: $job, hobbie: $hobbie, imgUrl: $img}';
  }
}



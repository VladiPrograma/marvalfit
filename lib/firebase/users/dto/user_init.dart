import 'package:marvalfit/firebase/users/model/user.dart';

class UserInitDTO{
  String id;
  String name;
  String email;
  String objective;
  
  UserInitDTO({required this.id,
 required this.name,
 required this.email,
 required this.objective});
  
  User modelFromDTO(){
    return User(
      id: id,
      name: name,
      lastName: '',
      work: '',
      email: email,
      active: true,
      hobbie: '',
      objective: objective,
      lastWeight: 0,
      currWeight: 0,
      update: DateTime.now(),
      lastUpdate: DateTime.now(),
      startDate: DateTime.now(),
      favoriteFood: '',
      phone: '',
      city: '',
      birthdate: DateTime.now(),
      height: 0,
      initialWeight: 0);
  }
}   

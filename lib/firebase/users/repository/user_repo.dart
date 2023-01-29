import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/users/model/user.dart';

final CollectionReference _db = FirebaseFirestore.instance.collection('users');

final _userEmitter = Emitter.stream((ref) async {
  final authId = await ref.watch(
      authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));
  return _db.doc(authId).snapshots();
}, keepAlive: true);

class UserRepository{

  User? get(Ref ref) {
    var query = ref.watch(_userEmitter.asyncData).data;
    return query?.data() !=null  ? User.fromMap(query!.data() as Map<String, dynamic>) : null;
  }

  Future<User?> getById() async {
      if(uid != null){
        final db = FirebaseFirestore.instance.collection('users');
        final query = await db.doc(uid).get();
        if(query.data() != null){
          return User.fromMap(query.data()!);
        }
      }
      return null;
  }

  Future<void> add(User user) {
    return _db.doc(user.id).set(user.toMap());
  }
  Future<void> update(Ref ref, Map<String, Object> map) async{
    final authId = await ref.watch(
        authEmitter.where((auth) => auth != null).map((auth) => auth!.uid));
    return _db.doc(authId).update(map);

  }

}
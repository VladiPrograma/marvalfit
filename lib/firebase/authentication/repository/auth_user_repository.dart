import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marvalfit/constants/firebase_constants.dart';
import 'package:marvalfit/firebase/authentication/model/auth_user_model.dart';

class AuthUserRepository{

  User? get(){  return FirebaseAuth.instance.currentUser; }


  Future<void> resetPassword(String password) async{
    return get()?.updatePassword(password);
  }
  Future<void> resetEmail(String email) async{
    return get()?.updateEmail(email);
  }
  Future<String?> signIn(AuthUser user) async{
    try {
      await FirebaseAuth.instance.
      signInWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
      return null;
    } on FirebaseAuthException catch (e){
      return e.code;
    }
  }
  Future<String> signUp(AuthUser user) async{
    FirebaseApp app = await Firebase.initializeApp( name: 'MarvalFitApp', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
      .createUserWithEmailAndPassword(email: user.email, password: user.password);
      app.delete();
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      app.delete();
      if(e.code == firebase_auth_code['email_exists']) return e.code;
      return firebase_auth_code['unexpected']!;
    }
  }
  Future<void> logOut() async{
    return FirebaseAuth.instance.signOut();
  }
}
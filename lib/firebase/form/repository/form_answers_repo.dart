import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/form/model/form_answers.dart';


final CollectionReference _db = FirebaseFirestore.instance.collection("forms");


final _formAnswersEmitter = Emitter.arg1<Map<String, dynamic>?, String>((ref, userId, emit) async{
  final query = await _db.doc(userId).get();
  emit(query.data() as Map<String, dynamic>?);
});

class FormAnswerRepo{

  FormAnswers? get(Ref ref, String userId) {
    Map<String, dynamic>? map = ref.watch(_formAnswersEmitter(userId).asyncData).data;
    return map != null ? FormAnswers.fromMap(map) : null;
  }
  Future<void> add(FormAnswers form, String userId) =>  _db.doc(userId).set(form.toMap());
  Future<void> update(String userId, Map<String, Object> map) =>  _db.doc(userId).update(map);
  Future<void> delete(String userId) =>  _db.doc(userId).delete();

}
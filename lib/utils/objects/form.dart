import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marvalfit/utils/marval_arq.dart';

import '../../config/log_msg.dart';
import '../../constants/string.dart';

class MarvalForm {
  static CollectionReference formsDB = FirebaseFirestore.instance.collection("forms");
  static String docName = "current_form";
  String key;
  String question;
  List<String> answers;
  int number;

  MarvalForm(this.key, this.question, this.answers, this.number);


  MarvalForm.fromJson(Map<String, dynamic> map)
      : key = map["key"],
        question = map["question"],
        answers = List<String>.from(map["answers"]),
        number = map["number"];

  static Future<void> setUserResponse(Map<String, Object> map) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return formsDB
        .doc(uid).set(map)
        .then((value) => logSuccess("$logSuccessPrefix Form Response Added"))
        .catchError((error) =>
        logError("$logErrorPrefix Failed to add Form Response: $error"));
  }
  Future<void> updateFormAnswer() {
    // Call the user's CollectionReference to add a new user
    return formsDB
        .doc(docName).update({
      key: {
        'key': key, // page1
        'question': question, // Que?
        'answers': answers, // [mek, si, tu padre, no]
        'number': number, // 1
      }
    })
        .then((value) => logSuccess("$logSuccessPrefix Form Item Added"))
        .catchError((error) =>
        logError("$logErrorPrefix Failed to add form Item: $error"));
  }

  static Future<bool> existsInDB(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await formsDB.doc(uid).get();
    return ds.exists;
  }

  @override
  String toString() {
    int cont=0;
    String res = "\n Key: $key Number: $number"
                 "\n $question";
    for (var element in answers) {  res+="\n $cont) $element"; cont++;}
    return res;
  }

  static Future<List<MarvalForm>> getFromDB() async {
    DocumentSnapshot doc = await formsDB.doc(docName).get();
    Map<String, dynamic>? map  = toMap(doc);
    List<MarvalForm> formList = [];
    map!.forEach((key, value) {
      formList.add(MarvalForm.fromJson(value));
    });
    return formList;
  }
}


void setForm(){
  List<String> questions = [
    '??Padeces alguna enfermedad respiratoria o de coraz??n?',
    '??Tienes lesiones o problemas musculares o articulares?',
    '??Tienes hernias u otras afecciones similares que puedan dificultar el trabajo con cargas?',
    '??Tienes problemas para conciliar el sue??o?',
    '??Cuanto fumas a la semana?',
    '??Padeces de hipertensi??n, diabetes o alguna enfermedad cr??nica?',
  ];
  List<List<String>> answers = [
    ['Si', 'No', kSpecifyText],
    ['Si', 'No', 'Prefiero no constestar', kSpecifyText],
    ['Si', 'No'],
    ['Duermo como un tronco','Duermo bien' 'Duermo mal', 'Necesito medicacion para dormir'],
    ['No fumo', '1 Paquete', '2 Paquetes', 'Entre 3 y 5 Paquetes', 'Mas de 5 Paquetes'],
    ['Si', 'No', kSpecifyText],
  ];
  int cont =1;
  for (var element in questions) {
    MarvalForm form = MarvalForm('page$cont', element, answers[cont-1], cont);
    form.updateFormAnswer();
    cont++;
  }
}






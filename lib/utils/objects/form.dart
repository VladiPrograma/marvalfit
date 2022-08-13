import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../config/log_msg.dart';
import '../marval_arq.dart';

class MarvalForm {
  static CollectionReference formsDB = FirebaseFirestore.instance.collection("forms");
  static String docName = "current_form";
  final String key;
  final String question;
  List<String> answers;
  int number;

  MarvalForm({required this.key, required this.question, required this.answers, required this.number});


  MarvalForm.fromJson(Map<String, dynamic> map)
      : key      = map["key"],
        question = map["question"],
        number   = map["number"],
        answers  = List<String>.from(map["answers"]);

  static Future<void> setUserResponse(Map<String, Object> map) async{

    return formsDB.doc(authUser.uid).set(map)
        .then((value) => logSuccess("$logSuccessPrefix Form Response Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to add Form Response: $error"));
  }
  Future<void> updateFormAnswer() {
    // Call the user's CollectionReference to add a new user
    return formsDB.doc(docName).update({
      key: {
        'key': key, // page1
        'question': question, // Que?
        'answers': answers, // [mek, si, tu padre, no]
        'number': number, // 1
      }
    }).then((value) => logSuccess("$logSuccessPrefix Form Item Added"))
        .catchError((error) => logError("$logErrorPrefix Failed to add form Item: $error"));
  }

  static Future<bool> existsInDB(String? uid) async{
    if(isNull(uid)){ return false;}
    DocumentSnapshot ds = await formsDB.doc(uid).get();
    return ds.exists;
  }

  @override
  String toString() {
    int cont=0;
    String res = "\n Key: $key Number: $number \n $question";
    for (var answer in answers) {
      res+="\n $cont) $answer";
      cont++;
    }
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
    '¿Padeces alguna enfermedad respiratoria o de corazón?',
    '¿Tienes lesiones o problemas musculares o articulares?',
    '¿Tienes hernias u otras afecciones similares que puedan dificultar el trabajo con cargas?',
    '¿Tienes problemas para conciliar el sueño?',
    '¿Cuanto fumas a la semana?',
    '¿Padeces de hipertensión, diabetes o alguna enfermedad crónica?',
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
  for (var question in questions) {
    MarvalForm form = MarvalForm(
        key: 'page$cont',
        question: question,
        answers: answers[cont-1],
        number: cont
    );
    form.updateFormAnswer();
    cont++;
  }
}






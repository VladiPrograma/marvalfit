import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/form/model/form_answers.dart';
import 'package:marvalfit/firebase/form/repository/form_answers_repo.dart';


class FormAnswersLogic{
  FormAnswerRepo repo = FormAnswerRepo();

  FormAnswers? get( Ref ref, String userId) {
    return repo.get(ref, userId);
  }

  List<String> getAnswers(Ref ref, String userId) {
    return get(ref, userId)?.form.values.toList() ?? [];
  }
  List<String> getQuestions(Ref ref, String userId) {
    return get(ref, userId)?.form.keys.toList() ?? [];
  }

}
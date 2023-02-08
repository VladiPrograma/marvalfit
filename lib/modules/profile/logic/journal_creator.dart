import 'package:creator/creator.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/habits/dto/habits_resume.dart';
import 'package:marvalfit/firebase/plan/model/plan.dart';

enum JournalState {DIARY, HABITS, GALLERY, MEASURES, LIST  }
List<String>   journalNames = ['Diario', 'Habitos', 'Galeria', 'Medidas'];
List<String> journalIcons = ['📓','🔆', '🎬', '📏'];

Creator<JournalState> _journalCreator = Creator.value(JournalState.LIST);

void updateJournal(JournalState state, Ref ref ){
  ref.update<JournalState>(_journalCreator, (p0) => state);
}
JournalState watchJournal(Ref ref){
  return ref.watch(_journalCreator);
}

Creator<HabitsResumeDTO?> _habitsCreator = Creator.value(null);


void updateHabitsCreator(HabitsResumeDTO? habit, Ref ref ){
  ref.update<HabitsResumeDTO?>(_habitsCreator, (p0) => habit);
}
HabitsResumeDTO? watchHabitsCreator(Ref ref){
  return ref.watch(_habitsCreator);
}

Creator<Plan?> _planCreator = Creator.value(null);

void initPlaning(Ref ref )async{
  Plan? plan = await planLogic.getByDate(DateTime.now());
  updatePlaning(plan, ref);
}

void updatePlaning(Plan? plan, Ref ref ){
  ref.update<Plan?>(_planCreator, (p0) => plan);
}
Plan? watchPlaning(Ref ref) => ref.watch(_planCreator);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/users/model/user.dart';

Creator<DateTime> _dateCreator = Creator.value(DateTime.now());
Creator<Daily>    _dailyCreator = Creator.value(Daily.empty());
Creator<bool>  _updateCreator = Creator.value(false);

class HomeController{

  DateTime getDate(Ref ref) => ref.watch(_dateCreator);
  void setDate(Ref ref, DateTime date) {
    ref.update<DateTime>(_dateCreator, (p0) => date);
    init(ref);
  }

  void hasChange(Ref ref) => ref.watch(_updateCreator);
  void onChange(Ref ref) => ref.update<bool>(_updateCreator, (value) => !value);

  Daily getDaily(Ref ref) => ref.watch(_dailyCreator);
  void setDaily(Ref ref, Daily daily) => ref.update<Daily>(_dailyCreator, (p0) => daily);


  void init(Ref ref) async{
    DateTime date =  getDate(ref);
    Daily? daily = await dailyLogic.getByDate(date);

    if(daily == null){
      User? user = await userLogic.getById();
      double lastWeight = user?.lastWeight ?? 0;

      await dailyLogic.add(ref, date, lastWeight);
      daily = await dailyLogic.getByDate(date);
    }

    setDaily(ref, daily!);
    onChange(ref);
  }

  updateCalendar(Ref ref, DateTime date) async{
    setDate(ref, date);
    Daily? daily = await dailyLogic.getByDate( date);
    if(daily == null) {
      User? user = await userLogic.getById();
      double weight = user?.currWeight ?? 0;
      daily = await dailyLogic.add(ref, date, weight);
    }
    setDaily(ref, daily);
    onChange(ref);
  }

  updateSleep(Ref ref, Daily daily, int position){
    bool isFirst = daily.sleep == 1 && position == 1;
    daily.sleep = isFirst ? 0 : position;
    logWarning("updateSleep Repaint sleep: ${daily.sleep}");
    dailyLogic.update(ref, daily.date, {'sleep' : daily.sleep});
    onChange(ref);
  }

  updateHabit(Ref ref, Daily daily, String habitName){
    if(daily.habits.contains(habitName)){
      dailyLogic.update(ref, daily.date, {
        'habits' : FieldValue.arrayRemove([habitName])
      });
      daily.habits.remove(habitName);
    }else{
      dailyLogic.update(ref, daily.date, {
        'habits' : FieldValue.arrayUnion([habitName])
      });
      daily.habits.add(habitName);
    }
    onChange(ref);
  }

  updateWeight(Ref ref, Daily daily, double weight){
    weight = double.parse(weight.toStringAsPrecision(3));
    // Firebase updates
    dailyLogic.update(ref, daily.date, {'weight' : weight});
    userLogic.updateWeight(ref, daily.weight,  weight);
    // Screen updates
    daily.weight = weight;
    onChange(ref);
  }


}
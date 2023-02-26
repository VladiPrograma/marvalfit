import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/cardio.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/gallery/logic/gallery_logic.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';
import 'package:marvalfit/firebase/gym_notes/logic/gym_notes_logic.dart';
import 'package:marvalfit/firebase/gym_notes/model/gym_notes.dart';
import 'package:marvalfit/firebase/measures/logic/measures_logic.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';
import 'package:marvalfit/firebase/storage/controller/storage_controller.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:marvalfit/utils/marval_arq.dart';

Creator<DateTime> _dateCreator = Creator.value(DateTime.now());
Creator<Daily>    _dailyCreator = Creator.value(Daily.empty());
Creator<bool>  _updateCreator = Creator.value(false);
Creator<Activity> _activityCreator = Creator.value(Activity.empty());
Creator<Measures?> _measuresCreator = Creator.value(null);
Creator<Gallery?> _galleryCreator = Creator.value(null);
Creator<GymNotes?> _gymNotesCreator = Creator.value(null);
Creator<bool> _saveIconCreator = Creator.value(false);

class HomeController{

  GymNotes? getGymNotes(Ref ref) => ref.watch(_gymNotesCreator);
  void setGymNotes(Ref ref, GymNotes? notes) => ref.update<GymNotes?>(_gymNotesCreator, (p0) => notes);

  bool getSaveFlag(Ref ref) => ref.watch(_saveIconCreator);
  void hasToSave(Ref ref) => ref.update<bool?>(_saveIconCreator, (p0) => true);
  void notHasToSave(Ref ref) => ref.update<bool?>(_saveIconCreator, (p0) => false);


  void initGymNotes(Ref ref, String id, Training training) async{
    GymNotes? notes = getGymNotes(ref);
    if( notes?.id != id){
      GymNotesLogic logic = GymNotesLogic();
      GymNotes? notes = await logic.getById(ref, id);
      notes ??= GymNotes.fromTraining(training);
      setGymNotes(ref, notes);
    }
  }
  void updateGymNotes(Ref ref, Daily daily, Activity activity, GymNotes notes) async{
    GymNotesLogic logic = GymNotesLogic();
    notes.date = daily.date;
    logic.add(ref, notes);
    activity.completed = true;
    updateActivity(ref, daily, activity);
  }



  Measures? getMeasures(Ref ref) => ref.watch(_measuresCreator);
  void setMeasures(Ref ref, Measures? measures) => ref.update<Measures?>(_measuresCreator, (p0) => measures);

  void initMeasures(Ref ref, String id) async{
    Measures? measures = getMeasures(ref);
    if( measures?.id != id){
      MeasuresLogic logic = MeasuresLogic();
      Measures? measures = await logic.getById(ref, id);
      setMeasures(ref, measures);
    }
  }

  Gallery? getGallery(Ref ref) => ref.watch(_galleryCreator);
  void setGallery(Ref ref, Gallery? gallery){
    //@TODO test this
    initActivity(ref);
    ref.update<Gallery?>(_galleryCreator, (p0) => gallery);

  }

  void initGallery(Ref ref, String id, Gallery? gallery) async{
    if( gallery?.id != id){
      GalleryLogic logic = GalleryLogic();
      Gallery? gallery = await logic.getById(ref, id);
      setGallery(ref, gallery);
    }
  }

  Future<Gallery> updateGalleryImages( Gallery gallery, DateTime date, Map<String, XFile?> map) async{
    StorageController controller = StorageController();
    if(map["Frontal"] != null){
      gallery.frontal = await controller.uploadGalleryImage(date, map["Frontal"]!);
    }
    if(map["Perfil"] != null){
      gallery.perfil = await  controller.uploadGalleryImage(date, map["Perfil"]!);
    }
    if(map["Espalda"] != null){
      gallery.espalda = await controller.uploadGalleryImage(date, map["Espalda"]!);
    }
    if(map["Piernas"] != null){
      gallery.piernas = await  controller.uploadGalleryImage(date, map["Piernas"]!);
    }
    return gallery;
  }
  Future<void> addGalleryActivity(Ref ref, Daily daily, Activity activity,  Map<String, XFile?> map) async{
    Gallery gallery = getGallery(ref) ?? Gallery.create(date: daily.date);
    await updateGalleryImages(gallery, daily.date, map);
    GalleryLogic galleryLogic = GalleryLogic();
    await galleryLogic.add(ref, gallery);
    if(isNullOrEmpty(activity.reference)){
      activity.reference = gallery.id;
    }
    activity.completed = true;
    updateActivity(ref, daily, activity);
  }

  DateTime getDate(Ref ref) => ref.watch(_dateCreator);
  void setDate(Ref ref, DateTime date) {
    ref.update<DateTime>(_dateCreator, (p0) => date);
    init(ref);
  }

  void hasChange(Ref ref) => ref.watch(_updateCreator);
  void onChange(Ref ref) => ref.update<bool>(_updateCreator, (value) => !value);

  Daily getDaily(Ref ref) => ref.watch(_dailyCreator);
  void setDaily(Ref ref, Daily daily) => ref.update<Daily>(_dailyCreator, (p0) => daily);

  Activity getActivity(Ref ref) => ref.watch(_activityCreator );
  void setActivity(Ref ref, Activity activity) => ref.update<Activity>(_activityCreator , (p0) => activity);
  void initActivity(Ref ref) => ref.update<Activity>(_activityCreator , (p0) => Activity.empty());

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
    setActivity(ref, Activity.empty());
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

  updateMeasures(Ref ref, Daily daily, Activity activity, Measures measures) async{
    MeasuresLogic measuresLogic = MeasuresLogic();
    await measuresLogic.add(ref, measures);
    activity.reference = measures.id;
    activity.completed = true;
    updateActivity(ref, daily, activity);
  }

  updateActivity(Ref ref, Daily daily, Activity activity){
    Activity oldActivity = daily.activities.where((item) => item.id == activity.id).first;
    oldActivity.clone(activity);
      dailyLogic.update(ref, daily.date, {
        'activities' : daily.activities.map((e) => e.toMap()).toList(),
      });
     onChange(ref);
  }

  updateCardio(Ref ref, Daily daily, Cardio cardio){
      daily.cardio.add(cardio);
      dailyLogic.update(ref, daily.date, {
        'cardio' : FieldValue.arrayUnion([cardio.toMap()])
      });
      onChange(ref);
  }

  removeCardio(Ref ref, Daily daily, Cardio cardio){
    daily.cardio.removeWhere((element) => element.id == cardio.id,);
    dailyLogic.update(ref, daily.date, {
      'cardio' : FieldValue.arrayRemove([cardio.toMap()])
    });
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
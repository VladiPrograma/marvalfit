import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:flutter/services.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/cardio.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/gym_notes/logic/gym_notes_logic.dart';
import 'package:marvalfit/firebase/gym_notes/model/gym_notes.dart';
import 'package:marvalfit/firebase/gym_notes/model/workout_notes.dart';
import 'package:marvalfit/firebase/trainings/logic/training_logic.dart';
import 'package:marvalfit/firebase/trainings/model/training.dart';
import 'package:marvalfit/firebase/trainings/model/workout.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/widgets/journal_title.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/utils/objects/planing.dart';
import 'package:marvalfit/widgets/load_indicator.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:sizer/sizer.dart';


import '../../../constants/colors.dart';
import '../../../constants/shadows.dart';
import '../../../constants/theme.dart';

///@TODO Add load icon when loading data.
///@TODO Make the save button availaible one time once to avoid multiple upload of the same images.
///

HomeController _controller = HomeController();

class AddWorkout extends StatelessWidget {
  const AddWorkout({required this.daily,required this.activity,  required this.ref,  Key? key}) : super(key: key);
  final Daily daily;
  final Activity activity;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String formatSeconds(int secs){
      int mins = secs ~/ 60;
      secs = secs % 60;
      String res = mins<9 ? '0$mins' : '$mins';
      res += secs<9 ? ':0$secs' : ':$secs';
      return res;
    }
    return  SizedBox( width: 100.w, height: 34.h,
        child:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
                children: [
                  JournalTitle(
                      name: activity.label,
                      topMargin: 2,
                    rightIcon: Watcher((context, ref, child) {
                      bool toSave = _controller.getSaveFlag(ref);
                      return GestureDetector(
                        onTap: (){
                          if ( _formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            GymNotes? gymNotes = _controller.getGymNotes(ref);
                            if(gymNotes != null){
                              _controller.updateGymNotes(ref, daily, activity, gymNotes);
                              _controller.initActivity(ref);
                              _controller.notHasToSave(ref);
                            }
                          }
                        },
                        child: Icon(Icons.save, color: toSave ?  kGreen : kGrey, size: 7.w,),
                      );
                    }),
                  ),
                  SizedBox(height: 2.h),
                  Watcher((context, ref, child){
                    TrainingLogic trainingLogic = TrainingLogic();
                    Training? training = trainingLogic.getByID(activity.id, ref);
                    if(training == null) return const SizedBox.shrink();

                    return Watcher((context, ref, child){
                      GymNotes? gymNotes = _controller.getGymNotes(ref);
                      if(gymNotes == null){
                        _controller.initGymNotes(ref, '${daily.id}_${training.id}', training);
                      }
                      if(gymNotes == null) return const LoadIndicator();
                      return Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [for( var workout in training.workouts)
                                SizedBox( width: 100.w,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(CustomIcons.info, color: kGreen, size: 4.w,),
                                          TextH2('  ${workout.name.maxLength(18)}  ',
                                            color: kWhite,
                                            size: 3.6,),
                                          const Spacer(),
                                          TextH2( workout.maxReps == workout.minReps ?
                                          '${workout.maxReps}  x ${workout.series}'
                                              :
                                          '${workout.maxReps} - ${workout.minReps} x ${workout.series}',
                                            color: kGrey,
                                            size: 3.6,),
                                          TextH2('  ${formatSeconds(workout.restSeconds)}',
                                            color: kGrey,
                                            size: 3.6,),
                                        ],
                                      ),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children:  [
                                          const TextH2('Series:   ',
                                            color: kGrey,
                                            size: 3.6,
                                          ),
                                          ...List.generate(gymNotes.workouts.firstWhereOrNull((element) => element.exercise == workout.exercise)?.reps.length ?? 0,
                                                  (index) =>    WorkoutTextField(
                                                  gymNotes: gymNotes,
                                                  index: index,
                                                  workoutNote: gymNotes.workouts.firstWhere((element) => element.exercise == workout.exercise)
                                              )
                                          ),
                                          WorkoutTextField(
                                            gymNotes: gymNotes,
                                            index: -1,
                                            textAlign: TextAlign.end,
                                            workoutNote: gymNotes.workouts.firstWhere((element) => element.exercise == workout.exercise),
                                            maxLenght: 2,
                                          ),
                                          const TextH2('Kg',
                                            color: kWhite,
                                            size: 3.6,
                                          ),
                                        ],)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h,)
                              ]
                          ),
                        ),
                      );
                    });
                  })
                ])
        ));
  }
}

class WorkoutTextField extends StatelessWidget {
  const WorkoutTextField({required this.gymNotes, required this.index,required this.workoutNote, this.width, this.textAlign,  this.maxLenght,   Key? key}) : super(key: key);
  final int? maxLenght;
  final int? width;
  final TextAlign? textAlign;
  final GymNotes gymNotes;
  final WorkoutNote workoutNote;
  final int index;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width?.w ?? 8.w, height: 6.h,
        child: TextFormField(
            cursorColor: kWhite,
            enableInteractiveSelection: false,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLenght ?? 2),
            ],
            cursorWidth: 0.1.w,
            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
            textAlign: textAlign ?? TextAlign.center,
            style: TextStyle(color: kWhite, fontSize: 3.6.w, fontFamily: h2),
            initialValue: index != -1 ? workoutNote.reps[index].toString() : workoutNote.weight.toString(),
            onSaved: (newValue) {
              if(newValue != null && newValue.isNotEmpty){
                int value = int.parse(newValue);
                index != -1 ? workoutNote.reps[index] = value : workoutNote.weight = value;
              }
            },
            onChanged: (value) => _controller.hasToSave(context.ref),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: kWhite, fontSize: 3.6.w),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            )
        ));
  }
}

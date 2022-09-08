import 'dart:io';

import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/custom_icons.dart';
import '../../config/log_msg.dart';

import '../../constants/colors.dart';
import '../../constants/shadows.dart';
import '../../constants/theme.dart';
import '../../constants/global_variables.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';

import '../../utils/objects/gallery.dart';
import '../../utils/firebase/storage.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';

import '../../widgets/marval_snackbar.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_textfield.dart';

import 'add_photos.dart';
import 'logic.dart';
import 'note_measures.dart';

bool rememberSave = false;

void _scrollDown(ScrollController controller){
  controller.animateTo(
      controller.positions.last.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutExpo
  );
}
void _scrollUp(ScrollController controller){
  controller.animateTo(
      controller.positions.last.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo
  );
}
/// JOURNAL WIDGET
class Journal extends StatelessWidget {
  const Journal({required this.controller, Key? key}) : super(key: key);
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      Daily? daily = getDaily(ref);
      if(isNull(daily)) return const SizedBox();
      String type = ref.watch(activityCreator);
      if(type == 'List'){
       _scrollDown(controller);
       ref.update(activityCreator, (p0) => 'Init');
      }

      if(type == 'Medidas') {
        _scrollUp(controller);
        return NoteMeasures(daily: daily);

      } else if(type == 'Galeria'){
        _scrollUp(controller);
        return AddPhotosToGallery(daily: daily);

      } else{ return MarvalActivityList(daily: daily);}
    });
  }
}

/// ACTIVITY LIST WIDGET */
class MarvalActivity extends StatelessWidget {
  const MarvalActivity({required this.activity, required this.daily, Key? key}) : super(key: key);
  final Map<String, dynamic>? activity;
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    logInfo(activity!);
    return  GestureDetector(
        onTap: () {
          String type = activity!['label'];
          if(isNotNull(daily)&&isNotNull(activity)){
            if(type == 'Descanso'){
              activity!['completed']= isNull(activity?['completed']) ? true : !activity!['completed'] ;
              daily!.updateActivity(activity!);
              /// Guardar en activities
            }
            else if(type == 'Pasos'){
              RichText _richText = RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: "Está demostrado que caminar quema más grasa y calorías que otros ejercicios, ayuda a que el sistema cardiovascular se active y fortifique, y te ayuda a eliminar el colesterol perjudicial para el organismo.",
                  style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                ),
              );
              int _steps = 0;
              GlobalKey<FormState> _formKey = GlobalKey();
              Form _form = Form(
                key: _formKey,
                child: MarvalInputTextField(
                  labelText: 'Pasos',
                  hintText: "",
                  prefixIcon: CustomIcons.leg,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(isNullOrEmpty(value)) return kEmptyValue;
                    try{
                      int.parse(value!);
                    }catch(e){
                      return 'Debes introducir un numero entero';
                    }
                    return null;
                  },
                  onSaved: (value){ _steps= int.parse(value!);},
                ),
              );
              MarvalDialogsInput(context,
                  title: '¡ Apunta tus pasos !',
                  height: 50,
                  form: _form,
                  richText: _richText,
                  onSucess: (){
                    if(isNull(activity?['completed'])){
                      activity!['completed']= true ;
                      daily!.updateActivity(activity!);
                    }
                    daily!.updateSteps(_steps);
                  }
              );
            }
            else if(type == 'Medidas'|| type == 'Galeria'){
              context.ref.update(activityCreator, (s) => activity!['label']);}
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12.w, height: 12.w,
              decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w))
              ),
              child: Center(child: Icon(mapIcons[activity?['icon']] ?? mapIcons[''], color: kWhite, size: 7.w,),),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                  color: kBlueSec,
                  borderRadius: BorderRadius.circular(3.w)
              ),
              child: Row(
                  children: [
                    TextH2(activity?['label'] ?? '', color: kWhite, size: 4.2,),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.w),
                            border: Border.all(
                                width: 0.4.w,
                                color: kWhite
                            )
                        ),
                        child:Watcher((context, ref, child) {
                          return CircleAvatar(
                            backgroundColor: isNull(activity?['completed'])  ? kBlack
                                : activity!['completed'] ? kBlue : kBlack,
                            radius: 1.8.w,
                          );
                        }))
                  ]),
            ),
          ],
        ));
  }
}
class MarvalActivityList extends StatelessWidget {
  const MarvalActivityList({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 34.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: isNull(daily) ? 1 : daily!.activities.length+1,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            controller: ScrollController( keepScrollOffset: true ),
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              if(index==0){
                return  Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 2.w,),
                        Icon(Icons.man_rounded, size: 5.w, color: kGreen,),
                        const TextH2(" Completa tus tareas", size: 4, color: kWhite,),
                      ]),
                );
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: MarvalActivity(daily: daily, activity: daily?.activities[index-1] ?? {},));
            }));
  }
}



/// GALLERY ICONS




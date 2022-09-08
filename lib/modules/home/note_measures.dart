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
import '../../utils/objects/measures.dart';
import '../../utils/firebase/storage.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';

import '../../widgets/marval_snackbar.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_elevated_button.dart';
import '../../widgets/marval_textfield.dart';

import 'journal.dart';
import 'logic.dart';
/// MEDIDAS WIDGET

/// LOGIC
Emitter<Measures?> measureEmitter = Emitter((ref, emit) async{
  Daily? daily = getDaily(ref);
  if(isNull(daily)) {emit(null);}
  String? reference = daily!.activities.where((element) => element['label']== 'Medidas').first['reference'];
  if(isNull(reference)) {emit(Measures.create(date: ref.watch(dateCreator)));}
  if(isNotNull(reference)) {emit(await Measures.getFromBD(daily.date));}
});

///@TODO Show image when clicking on info icon to see how the hell is supose to take the measures.
///Widget
DataRow MeasureDataRow(String text, double num){
  return DataRow(cells: [
    DataCell(SizedBox(width: 40.w, child:TextH2(text, size: 4, color: kWhite, textAlign: TextAlign.start))),
    DataCell(SizedBox(width: 30.w, child:
    TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        scrollPadding: EdgeInsets.only(bottom: 37.h),
        cursorColor: kGreen,
        style: TextStyle(fontFamily: h2, fontSize: 4.w, color: kWhite),
        decoration:  InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(fontFamily: h2, fontSize: 4.w, color: kWhite),
          hintText: num==0 ? '0' : num.toStringAsPrecision(3),
        ),
        onTap: ()=> rememberSave = true,
        onSaved: (newValue) {
          if(isNotNull(newValue)&&isNotEmpty(newValue)){
            try{
              _bodyParts?[text] = double.parse(newValue!);
            }catch(e){
              logError(e);
            }}
        }))
    )]);
}


final _formKey = GlobalKey<FormState>();
Map<String, double>? _bodyParts;

class NoteMeasures extends StatelessWidget {
  const NoteMeasures({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:  SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form( key: _formKey,
              child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox( width: 20.w,
                          child: GestureDetector(
                            child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                            onTap: (){
                              if(rememberSave){
                                MarvalDialogsAlert(context, type: MarvalDialogAlertType.DELETE, height: 28,
                                 title: '¿ Salir sin guardar? ',
                                 richText: RichText(text: TextSpan(text: 'Si sales sin guardar tus datos se perderan para siempre',
                                   style: TextStyle(fontFamily: p2, fontSize: 4.w, color: kBlack),)),
                                 acceptText: 'Salir',
                                 onAccept: (){
                                   context.ref.update(activityCreator, (t) => 'List');
                                   rememberSave=false;}
                                );}
                              else{
                                context.ref.update(activityCreator, (t) => 'List');
                              }},
                          )),
                          const TextH2("Apunta tus medidas", size: 4, color: kWhite,),
                          SizedBox( width: 20.w,
                              child: GestureDetector(
                                onTap: (){ /**@TODO implement video or image or something*/ },
                                child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                              )),
                        ]),
                    Watcher((context, ref, child){
                      Measures? measure = ref.watch(measureEmitter.asyncData).data;
                      ///@TODO Avoid data clipping instance when fetching measures
                      ///@TODO Change hint text when fetching data ?¿
                      if(isNull(measure)) return const SizedBox();
                      _bodyParts = measure!.bodyParts();
                      return DataTable(
                        border: const TableBorder(horizontalInside: BorderSide(color: kWhite)),
                        columns:  [
                          DataColumn(label: SizedBox(width: 40.w,
                          child: const TextH2('Zona',
                              size: 4,
                              color: kWhite,
                              textAlign: TextAlign.start
                          ))),
                          DataColumn(label: SizedBox(width: 30.w,
                          child: const TextH2('Medida (cm)',
                              size: 4,
                              color: kWhite,
                              textAlign: TextAlign.center
                          ))),
                        ],
                        rows: [
                         MeasureDataRow(bodyParts[0],  measure.ombligo),
                         MeasureDataRow(bodyParts[1],  measure.ombligoP2),
                         MeasureDataRow(bodyParts[2],  measure.ombligoM2),
                         MeasureDataRow(bodyParts[3],  measure.cadera),
                         MeasureDataRow(bodyParts[4],  measure.contPecho),
                         MeasureDataRow(bodyParts[5],  measure.contPecho),
                         MeasureDataRow(bodyParts[6],  measure.gemeloIzq),
                         MeasureDataRow(bodyParts[7],  measure.gemeloDrch),
                         MeasureDataRow(bodyParts[8],  measure.musloIzq),
                         MeasureDataRow(bodyParts[9],  measure.musloDrch),
                         MeasureDataRow(bodyParts[10], measure.bicepsIzq),
                         MeasureDataRow(bodyParts[11], measure.bicepsDrch),
                        ],
                      );
                    }),
                    SizedBox(height: 5.h,),
                    ///Upload Button
                    MarvalElevatedButton('Guardar',
                        backgroundColor: MaterialStateColor.resolveWith((states) => kGreen.withOpacity(0.9)),
                        onPressed: (){
                          if (_formKey.currentState!.validate()&&isNotNull(daily)&& rememberSave) {
                            _formKey.currentState!.save();
                            rememberSave = false;
                            /// FIREBASE DAILY UPDATE
                            String reference = daily!.id+idMeasures;
                            Map<String, dynamic> activity = daily!.activities.where((element) => element['label']=='Medidas').first;
                            activity['completed']= true;
                            activity['reference']= reference;
                            daily!.updateActivity(activity);
                            /// FIREBASE MEASURE UPDATE
                            Measures measure = Measures.fromMap(date: daily!.date, map: _bodyParts! );
                            measure.setInDB().whenComplete((){
                              MarvalSnackBar(context, SNACKTYPE.success,
                                  title: 'Nuevas medidas apuntadas!',
                                  subtitle: 'Aquellos que quieren cantar siempre encuentran una canción');
                            });
                          }
                        }),
                    ///Down Logo @TODO Change with a logo image
                    Container(height: 25.h,
                        padding: EdgeInsets.only(top: 10.h),
                        ///@TODO Cambiar por un negativo del logo de Mario
                        child: const TextH1('MarvalFit', color: kGreenThi, size: 8,)
                    ),
                  ])
          ),
        )
    );
  }
}

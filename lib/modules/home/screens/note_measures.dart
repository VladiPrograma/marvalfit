import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/measures/logic/measures_logic.dart';
import 'package:marvalfit/firebase/measures/model/measures.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/widgets/journal_title.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:sizer/sizer.dart';

HomeController _controller = HomeController();
Map<String, dynamic> _measuresMap = Measures.create(date: DateTime.now()).toMap();
final _formKey = GlobalKey<FormState>();

class NoteMeasures extends StatelessWidget {
  const NoteMeasures({required this.daily,required this.activity, required this.ref, Key? key}) : super(key: key);
  final Daily daily;
  final Activity activity;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    return SizedBox( width: 100.w, height: 34.h,
        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form( key: _formKey,
              child: Column(
                  children: [
                    JournalTitle(name: r'Apunta tus medidas',
                    topMargin: 2,
                    rightIcon:  GestureDetector(
                         onTap: (){
                           /**@TODO implement video or image or something*/
                         },
                         child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                       )
                     ),
                    Watcher((context, ref, child){
                      DateTime date = _controller.getDate(ref);
                      Measures? measure = _controller.getMeasures(ref);
                      if(activity.reference.isNotEmpty){
                        _controller.initMeasures(ref, activity.reference);
                      }
                      measure ??= Measures.create(date: DateTime.now());
                      _measuresMap =  measure.toMap();
                      logInfo(_measuresMap);
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        child: DataTable(
                          border: const TableBorder(horizontalInside: BorderSide(color: kWhite)),
                          columns:  [
                            DataColumn(label: SizedBox(width: 13.w,
                            child: const TextH2('Zona',
                                size: 3.6,
                                color: kWhite,
                                textAlign: TextAlign.start
                            ))),
                            DataColumn(label: SizedBox(width: 18.w,
                                child: const TextH2('Medidas',
                                size: 3.6,
                                color: kWhite,
                                textAlign: TextAlign.start
                            ))),
                          ],
                          rows: [
                           MeasureDataRow( 'Ombligo', measure.ombligo, 'ombligo'),
                           MeasureDataRow( 'Ombligo +2cm', measure.ombligoP2, 'ombligo_p2'),
                           MeasureDataRow( 'Ombligo -2cm', measure.ombligoM2, 'ombligo_m2'),
                           MeasureDataRow( 'Cadera', measure.cadera, 'cadera'),
                           MeasureDataRow( 'Cont. pecho', measure.contPecho, 'cont_pecho'),
                           MeasureDataRow( 'Cont. hombros', measure.contPecho, 'cont_hombros'),
                           MeasureDataRow( 'Gemelo izq', measure.gemeloIzq, 'gemelo_izq'),
                           MeasureDataRow( 'Gemelo drch', measure.gemeloDrch, 'gemelo_drch'),
                           MeasureDataRow( 'Muslo izq', measure.musloIzq, 'muslo_izq'),
                           MeasureDataRow( 'Muslo drch', measure.musloDrch, 'muslo_drch'),
                           MeasureDataRow( 'Biceps izq', measure.bicepsIzq, 'biceps_izq'),
                           MeasureDataRow( 'Biceps drch', measure.bicepsDrch, 'biceps_drch'),
                          ]),
                      );
                    }),
                    SizedBox(height: 3.h,),
                    ///Upload Button
                    MarvalElevatedButton('Guardar',
                        backgroundColor: MaterialStateColor.resolveWith((states) => kGreen.withOpacity(0.9)),
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            _measuresMap['date'] = Timestamp.fromDate(daily.date);
                            Measures measures = Measures.fromMap(_measuresMap);
                            measures.date = daily.date;
                            _controller.updateMeasures(ref, daily, activity, measures);
                            _controller.initActivity(ref);
                          }
                        }),
                    SizedBox(height: 3.h,),
                  ])
          ),
        )
    );
  }
}
DataRow MeasureDataRow(String text, double num, String key){
  return DataRow(cells: [
    DataCell(SizedBox(width: 30.w, child: TextH2(text, size: 3.4, color: kWhite, textAlign: TextAlign.start))),
    DataCell(Container(width: 8.w,
        margin: EdgeInsets.only(left: 4.w),
        child: TextFormField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        scrollPadding: EdgeInsets.only(bottom: 37.h),
        cursorColor: kGreen,
        style: TextStyle(fontFamily: h2, fontSize: 3.4.w, color: kWhite),
        decoration:  InputDecoration(
          fillColor: kBlue,
          border: InputBorder.none,
          hintStyle: TextStyle(fontFamily: h2, fontSize: 3.4.w, color: kWhite),
          hintText: num==0 ? '0' : num.toInt().toString(),
        ),
        onSaved: (newValue) {
            if(isNotNullOrEmpty(newValue)){
              try{
                _measuresMap[key] = double.parse(newValue!);
              }catch(e){
                logError(e);
              }}
            }
        ))
    )]);
}
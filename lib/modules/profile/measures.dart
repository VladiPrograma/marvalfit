import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/modules/profile/logic.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/measures.dart';


ScrollController _returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ _fetchMoreMeasures(ref); }});
  return res;
}
final _measuresEmitter = Emitter.stream((ref) async {
  return  FirebaseFirestore.instance.collection('users/${authUser.uid}/activities')
      .where('type', isEqualTo: idMeasures)
      .orderBy('date', descending: true).limit(ref.watch(_page)).snapshots();
});
final _page = Creator.value(3);
void  _fetchMoreMeasures(Ref ref,{int? add}) => ref.update<int>(_page, (n) => n + (add ?? 3));
List<Measures>? _getLoadMeasures(Ref ref){
  final query = ref.watch(_measuresEmitter.asyncData).data;
  if(isNull(query)||query!.size==0){ return null; }
  //Pass data from querySnapshot to Messages
  final List<Measures> list = _queryToData(query);

  return list;
}

///* Internal Logic ///
List<Measures> _queryToData(QuerySnapshot<Map<String, dynamic>> query){
  List<Measures> list = [];
  for (var element in [...query.docs]){
    list.add(Measures.fromJson(element.data()));
  }
  return list;
}

class MeasureLabel extends StatelessWidget {
  const MeasureLabel({required this.measure, Key? key}) : super(key: key);
  final Measures measure;
  @override
  Widget build(BuildContext context) {
    return Container( width: 80.w, height: 92.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:  Column(
            children: [
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width:20.w, height: 0.2.w, color: kWhite,),
                    TextH1(' ${measure.date.id} ', color: kWhite, size: 5,),
                    Container(width:20.w, height: 0.2.w, color: kWhite,),
                  ]),
              DataTable(
                border: const TableBorder(horizontalInside: BorderSide(color: kWhite)),
                columns:  [
                  DataColumn(
                      label: SizedBox(width: 40.w,
                          child: const TextH2('Zona', size: 4, color: kWhite, textAlign: TextAlign.start
                          ))),
                  DataColumn(
                      label: SizedBox(width: 30.w,
                          child: const TextH2('Medida (cm)', size: 4, color: kWhite, textAlign: TextAlign.center
                          ))),
                ],
                rows: [
                  _MeasureDataRow(bodyParts[0],  measure.ombligo),
                  _MeasureDataRow(bodyParts[1],  measure.ombligoP2),
                  _MeasureDataRow(bodyParts[2],  measure.ombligoM2),
                  _MeasureDataRow(bodyParts[3],  measure.cadera),
                  _MeasureDataRow(bodyParts[4],  measure.contPecho),
                  _MeasureDataRow(bodyParts[5],  measure.contPecho),
                  _MeasureDataRow(bodyParts[6],  measure.gemeloIzq),
                  _MeasureDataRow(bodyParts[7],  measure.gemeloDrch),
                  _MeasureDataRow(bodyParts[8],  measure.musloIzq),
                  _MeasureDataRow(bodyParts[9],  measure.musloDrch),
                  _MeasureDataRow(bodyParts[10], measure.bicepsIzq),
                  _MeasureDataRow(bodyParts[11], measure.bicepsDrch),
                ],
              ),
              SizedBox(height: 2.h,),
            ])
    );
  }
}
DataRow _MeasureDataRow(String text, double num){
  return DataRow(cells: [
    DataCell(SizedBox(width: 40.w, child:TextH2(text, size: 4, color: kWhite, textAlign: TextAlign.start))),
    DataCell(SizedBox(width: 30.w, child:TextH2(num==0 ? '0' : num.toStringAsPrecision(3), size: 4, color: kWhite, textAlign: TextAlign.center))),
  ]);
}

class MeasureList extends StatelessWidget {
  const MeasureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w, height: 76.h,
        child: Watcher((context, ref, child) {
          List<Measures>? measures = _getLoadMeasures(ref);
          if(isNull(measures)){ return Container(width: 100.w,
              margin: EdgeInsets.only(top: 2.h),
              child : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox( width: 20.w,
                        child: GestureDetector(
                          child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                          onTap: ()=> context.ref.update(journalCreator, (t) => 'List'),
                        )),
                    const TextH2("Revisa tus medidas", size: 4, color: kWhite,),
                    SizedBox( width: 20.w,
                        child: GestureDetector(
                          onTap: (){ /**@TODO implement video or image or something*/ },
                          child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                        )),
                  ])
          );}
          return ListView.builder(
              controller: _returnController(ref),
              itemCount: measures!.length+1,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                /// Title
                if(index==0){
                  return SizedBox(width: 100.w,
                      child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox( width: 20.w,
                                child: GestureDetector(
                                  child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                                  onTap: ()=> context.ref.update(journalCreator, (t) => 'List'),
                                )),
                            const TextH2("Revisa tus medidas", size: 4, color: kWhite,),
                            SizedBox( width: 20.w,
                                child: GestureDetector(
                                  onTap: (){ /**@TODO implement video or image or something*/ },
                                  child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                                )),
                          ])
                  );
                }
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: MeasureLabel(measure: measures[index-1],));
              });
        }));
  }
}






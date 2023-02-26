import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/cardio.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/widgets/journal_title.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/widgets/marval_textfield.dart';
import 'package:sizer/sizer.dart';


import '../../../constants/colors.dart';
import '../../../constants/shadows.dart';
import '../../../constants/theme.dart';

///@TODO Add load icon when loading data.
///@TODO Make the save button availaible one time once to avoid multiple upload of the same images.
///

HomeController _controller = HomeController();

Creator<String> inputValue = Creator.value('0');
String watchInputValue(Ref ref) => ref.watch(inputValue);
void updateInputValue(Ref ref, String value) => ref.update(inputValue, (p0) => value);


class AddCardio extends StatelessWidget {
  const AddCardio({required this.daily,required this.activity,  required this.ref,  Key? key}) : super(key: key);
  final Daily daily;
  final Activity activity;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    CardioType cardioType = CardioType.WALK;
    CardioMeasure cardioMeasure = CardioMeasure.CAL;
    return  SizedBox( width: 100.w, height: 34.h,
        child:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
                children: [
                  JournalTitle(
                      name: r'Apunta el cardio',
                      topMargin: 2,
                      rightIcon: Watcher((context, ref, child) {
                       String value = watchInputValue(ref);
                       int parseValue = 0;
                         parseValue = int.parse(value);
                         if(parseValue <= 0){
                          return Icon(Icons.save, color: kGrey, size: 7.w,);
                       }
                       return GestureDetector(
                         onTap: (){
                           int numValue = int.parse(watchInputValue(ref));
                           Cardio cardio = Cardio(date: DateTime.now(), type: cardioType, measure: cardioMeasure, num: numValue );
                           activity.completed = true;
                           _controller.updateActivity(ref, daily, activity);
                           _controller.updateCardio(ref, daily, cardio);
                           updateInputValue(ref, '0');
                         },
                         child: Icon(Icons.save, color: kGreen, size: 7.w,),
                       );
                      })
                  ),
                  SizedBox(height: 2.h),
                   Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DropDown(labels: cardioNames.values.toList(),
                           onChanged:(newValue){
                             if(newValue != null){
                               cardioType = cardioNames.keys.where((element) => cardioNames[element] == newValue).first;
                             }
                           }),
                          SizedBox(width: 2.w,),
                          MarvalInputTextField(width: 30.w,
                          prefixIcon: Icons.calculate,
                          keyboardType: TextInputType.number,
                          initialValue: '0',
                          onChanged: (value){
                            updateInputValue(ref, value ?? '0');
                          }),
                          SizedBox(width: 2.w,),
                           _DropDown(labels: cardioMeasureNames.values.toList(),
                           onChanged:(newValue){
                             if(newValue != null){
                               cardioMeasure = cardioMeasureNames.keys.where((element) => cardioMeasureNames[element] == newValue).first;
                             }
                           }),
                        ]),
                  SizedBox(height: 3.h),
                  Container(width: 90.w, height: 0.2.h, color: kWhite,),
                  CardioList(daily: daily, ref: ref,),
                  SizedBox(height: 3.h),
                ])
        ));
  }
}


class _DropDown extends StatelessWidget {
  const _DropDown({required this.onChanged, required this.labels, Key? key}) : super(key: key);
  final List<String> labels;
  final Function(String? value) onChanged;
  @override
  Widget build(BuildContext context) {
    Creator<String?> _dropDownCreator = Creator.value(null);
    String? _getDropDownValue(Ref ref) => ref.watch(_dropDownCreator);
    void _setDropDownValue(Ref ref, String? value) => ref.update(_dropDownCreator, (t) => value);

    return Container( width:  31.w, height: 8.h,
        decoration: BoxDecoration(
          color: kWhite,
          boxShadow: [kMarvalBoxShadow],
          borderRadius: BorderRadius.all(Radius.circular(4.w)),
        ),
        child: Center(child:
        Row(children: [
          SizedBox(width: 2.w,),
          Watcher((context, ref, child){
            final value = _getDropDownValue(ref);
            return DropdownButton<String>(
                borderRadius : BorderRadius.all(Radius.circular(4.w)),
                underline    : const SizedBox(),
                style : TextStyle(  fontFamily: p1, fontSize: 4.w, color: kBlack),
                value : labels.contains(value) ? value : labels.first,
                items : labels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child:  Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  onChanged(newValue);
                  if(newValue == labels.first){
                    _setDropDownValue(ref, null);
                  }else{
                    _setDropDownValue(ref, newValue);
                  }
                }
            );}),
        ])));
  }
}


class CardioList extends StatelessWidget {
  const CardioList({required this.daily, required this.ref, Key? key}) : super(key: key);
  final Daily daily;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 15.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: isNull(daily) ? 0 : daily.cardio.length,
            scrollDirection: Axis.vertical,
            controller: ScrollController( keepScrollOffset: true ),
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: CardioLabel( daily: daily, ref: ref, cardio: daily.cardio[index]));
            }));
  }
}
class CardioLabel extends StatelessWidget {
  const CardioLabel({required this.cardio, required this.daily, required this.ref, Key? key}) : super(key: key);
  final Cardio cardio;
  final Daily daily;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox( width: 20.w, child: TextH2(cardioNames[cardio.type].toString(), color: kWhite, size: 3.4, textAlign: TextAlign.start,)),
        SizedBox( width: 20.w, child: TextH2(cardio.num.toString(), color: kWhite, size: 3.4,  textAlign: TextAlign.center)),
        SizedBox( width: 20.w, child: TextH2(cardioMeasureNames[cardio.measure].toString(), color: kWhite, size: 3.4,  textAlign: TextAlign.center)),
        SizedBox( width: 20.w, child: TextH2(cardio.date.toFormatStringHour(), color: kWhite, size: 3.4,  textAlign: TextAlign.center)),
        SizedBox( width: 12.w, child: GestureDetector(
          onTap: (){
            _controller.removeCardio(ref, daily, cardio);
          },
          child: Icon(Icons.cancel, color: kRed, size: 5.w,),
        ))
      ],
    ),);
  }
}

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';
import 'logic.dart';

ScrollController _returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ fetchMoreDays(ref); }});
  return res;
}

class Diary extends StatelessWidget {
  const Diary({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Watcher((context, ref, child) {
      List<Daily>? dailys = getLoadDailys(ref);

      if(isNull(dailys)||dailys!.isEmpty) {
        return Container(width: 100.w,
            margin: EdgeInsets.only(top: 3.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5.w,),
                  SizedBox( width: 20.w,
                      child: GestureDetector(
                        child: Align(alignment: Alignment.centerLeft, child:
                        Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen)),
                        onTap: (){ context.ref.update(journalCreator, (p0) => 'List');},
                      )),
                  const TextH2("Revista tus datos", size: 4, color: kWhite,),
                  SizedBox( width: 25.w),
                ]));
      }
      return SizedBox(width: 100.w, height: 72.h,
          child: ListView.separated(
            controller: _returnController(ref),
            itemCount: dailys.length+1,
            itemBuilder: (context, index){
              if(index==0){ return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 5.w,),
                    SizedBox( width: 20.w,
                        child: GestureDetector(
                          child: Align(alignment: Alignment.centerLeft, child:
                          Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen)),
                          onTap: (){ context.ref.update(journalCreator, (p0) => 'List');},
                        )),
                    const TextH2("Revista tus datos", size: 4, color: kWhite,),
                    SizedBox( width: 25.w),
                  ]);}
              return Container(margin: EdgeInsets.symmetric(horizontal: 12.w), child: DiaryDailyInput(daily: dailys[index-1]));
            } ,
            separatorBuilder: (context, index) => SizedBox(height: 3.h,),
          ));
    });
  }
}
class DiaryDailyInput extends StatelessWidget {
  const DiaryDailyInput({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    if(isNull(daily)) { return const SizedBox();
    } else{
      List<String> habits = daily!.habitsFromPlaning!.map((e) => e['label'].toString()).toList();
      List<String> activities = daily!.activities.where((element) => element['completed']==true).map((e) => e['label'].toString()).toList();
      activities.remove('Pasos');
      return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: kWhite, width: 0.4.w),
                  right: BorderSide(color: kWhite, width: 0.4.w),
                  bottom: BorderSide(color: kWhite, width: 0.4.w)
              )
          ),
          child:Column( children: [
            Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 15.w, height: 0.2.h, color: kWhite, margin: EdgeInsets.only(right: 4.w),),
                  TextH1(daily!.id, size: 4, color: kWhite),
                  Container(width: 15.w, height: 0.2.h, color: kWhite, margin: EdgeInsets.only(left: 4.w),),
                ]),
            SizedBox(height: 1.h,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.label_important_outline_rounded, color: kWhite, size: 3.w),
                  SizedBox(width: 3.w,),
                  TextH2('Peso: ${daily!.weight} Kg', size: 3.5, color: kWhite ),
                ]),
            SizedBox(height: 1.h,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.label_important_outline_rounded, color: kWhite, size: 3.w),
                  SizedBox(width: 3.w,),
                  const TextH2('Sueño:  ', size: 3.5, color: kWhite),
                  Row(children: List.generate(daily!.sleep, (index) => Icon(CustomIcons.moon_inv, color: kBlue, size: 5.w,),),)
                ]),
            Column(children: List.generate(habits.length~/3, (index) =>
                Column(children: [
                  SizedBox(height: 1.h,),
                  Row(children:[
                    Icon(Icons.label_important_outline_rounded, color: kWhite, size: 3.5.w),
                    SizedBox(width: 3.w,),
                    TextH2('${habits[(index*3)]}   ', size: 3.5,
                        color: daily!.habits.contains(habits[index*3]) ? kGreen : kWhite),
                    TextH2('${habits[(index*3)+1]}   ', size: 3.5,
                        color: daily!.habits.contains(habits[index*3+1]) ? kGreen : kWhite),
                    TextH2('${habits[(index*3)+2]}   ', size: 3.5,
                        color: daily!.habits.contains(habits[index*3+2]) ? kGreen : kWhite),
                  ])
                ],))),
            SizedBox(height: 1.h,),
            Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.label_important_outline_rounded, color: kWhite, size: 3.w),
                  SizedBox(width: 3.w,),
                  TextH2('Pasos: ${daily!.steps ?? 0}  ', size: 3.5, color: kWhite ),
                  daily?.steps == 0 ? SizedBox() : Icon(CustomIcons.leg, color: kBlue, size: 5.w),
                ]),
            SizedBox(height: 1.h,),
            Column(children: List.generate(activities.length, (index) =>
                Row( mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.label_important_outline_rounded, color: kWhite, size: 3.w),
                      SizedBox(width: 3.w,),
                      TextH2(activities[index], size: 3.5, color: kWhite),

                    ]))),
          ]));
    }
  }
}
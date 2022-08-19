import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../constants/string.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';
import '../../widgets/marval_dialogs.dart';
import 'logic.dart';

///HABIT LABELS
Creator<String> habitsCreator = Creator.value('List');
ScrollController _returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ fetchMoreDays(ref, add: 31); }});
  return res;
}

class HabitLabel extends StatelessWidget {
  const HabitLabel({ required this.habit, Key? key}) : super(key: key);
  final Map<String, dynamic> habit;
  @override
  Widget build(BuildContext context) {
    return   Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
            onTap: (){ MarvalDialogsInfo(context, 40,
                title: habit['name'] ?? '',
                richText:RichText(
                  text: TextSpan(text: habit['description'],
                      style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack)),));
            },
            child:Container(width: 12.w, height: 12.w,
              decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w))
              ),
              child: Center(child: Icon(CustomIcons.info, color: kWhite, size: 7.w,),),
            )),
        SizedBox(width: 6.w,),
        GestureDetector(
            onTap: () {
              fetchOneMonth(context.ref);
              context.ref.update(habitsCreator, (p0) => habit['label']);
            },
            child:Container(width: 50.w, height: 12.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    color: kBlueSec,
                    borderRadius: BorderRadius.circular(3.w)
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextH2(habit['label'], color: kWhite, size: 4.2),
                )
            )),
      ],
    );
  }
}
class HabitList extends StatelessWidget {
  const HabitList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w, height: 80.h, child: Watcher((context, ref, child) {
      Daily? daily = getLoadDailys(ref)?.first;
      String type = ref.watch(habitsCreator);
      if(isNull(daily)){ return SizedBox();}
      if(type=='List'){
        return ListView.separated(
            itemCount: daily!.habitsFromPlaning!.length+1,
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => SizedBox(height: 2.h,),
            itemBuilder: (context, index) {
              /// Title
              if(index==0){
                return SizedBox(width: 100.w,
                    child: Row( mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5.w,),
                          SizedBox( width: 35.w,
                              child: GestureDetector(
                                onTap: (){ context.ref.update(journalCreator, (p0) => 'List');},
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen)
                                ),
                              )),
                          const TextH2("Habitos", size: 4, color: kWhite,),
                          SizedBox( width: 35.w),
                        ]));
              }
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: HabitLabel(habit: daily.habitsFromPlaning![index-1]));
            });
      }
      else{
        return CalendarList(habit: type,);
      }
    }));
  }
}

class CalendarList extends StatelessWidget {
  const CalendarList({required this.habit, Key? key}) : super(key: key);
  final String habit;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          SizedBox(height: 4.h,),
          SizedBox(width: 100.w,
              child: Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 5.w,),
                    SizedBox( width: 30.w,
                        child: GestureDetector(
                          onTap: (){ context.ref.update(habitsCreator, (p0) => 'List');},
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen)
                          ),
                        )),
                    TextH2(habit, size: 4, color: kWhite,),
                    SizedBox( width: 30.w),
                  ])),
          Watcher((context, ref, child){
            List<Daily>? dailys = getLoadDailys(ref);
            if(isNull(dailys)) return SizedBox();
            final lastDate = dailys!.first.date;
            int monthDifference = dailys.last.date.monthDifference(lastDate);

            return SizedBox(width: 80.w, height: 63.h,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: _returnController(ref),
                  itemCount: monthDifference+1,
                  itemBuilder: (context, index){
                    var nextMonth =  DateTime(lastDate.year, lastDate.month - index, lastDate.day);
                    List<bool> list = getCalendarHabitList(dailys, nextMonth, habit);
                    return Calendar(habits: list, date: nextMonth);
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 5.h,),
                ));
          })
        ]);
  }
}

List<bool> getCalendarHabitList(List<Daily> list, DateTime date, String habit){
  final monthList = list.where((daily) => daily.date.month == date.month && daily.date.year == date.year).toList();
  if(monthList.isEmpty) return [];
  List<bool> habitList = List.generate(monthList.first.date.monthDays(), (index) => false);
  for (var daily in monthList) {
    habitList[daily.date.day-1] = daily.habits.contains(habit);
  }
  return habitList;
}

class Calendar extends StatelessWidget {
  const Calendar({required this.habits, required this.date,  Key? key}) : super(key: key);
  final List<bool?> habits;
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return
      Container(width: 80.w, height: 38.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: kWhite, width: 0.2.w),
                  right: BorderSide(color: kWhite, width: 0.2.w),
                  bottom: BorderSide(color: kWhite, width: 0.2.w)
              )),
          child:
          Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 13.w, height: 0.2.w, color: kWhite,),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          child: TextH1('${date.toStringMonth()}, de ${date.year}', size: 5, color: kWhite)),
                      Container(width: 13.w, height: 0.2.w, color: kWhite,),
                    ]),
                SizedBox(height: 2.h,),
                Container(width: 80.w, height: 31.h,
                    padding: EdgeInsets.symmetric(horizontal: 1.w),
                    child: GridView.count(
                        crossAxisCount: 7,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(date.monthDays(), (index) =>
                            Padding(padding: EdgeInsets.all(1.w),
                                child:  CircleAvatar(radius: 7.w, backgroundColor: habits[index]! ? kGreen : kWhite,
                                  child: TextH1('${index+1}', color: habits[index]! ? kWhite : kBlack, size: 4,),)))
                    ))]
          ));
  }
}
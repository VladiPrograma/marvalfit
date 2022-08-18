import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';
import '../../utils/decoration.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user.dart';
import '../../utils/objects/user_daily.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_drawer.dart';
import 'diary.dart';
import 'logic.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MarvalDrawer(name: "Perfil",),
        backgroundColor: kWhite,
        body:  SizedBox( width: 100.w, height: 100.h,
          child: Stack(
            children: [
             /// Grass Image
             Positioned( top: 0,
             child: SizedBox(width: 100.w, height: 12.h,
             child: Image.asset('assets/images/grass.png',
             fit: BoxFit.cover
             ))),
             ///White Container
             Positioned( top: 8.h,
              child: Container(width: 100.w, height: 10.h,
               decoration: BoxDecoration(
               color: kWhite,
               borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w)
               ))
             )),
             /// User Box Data
             Positioned(  top: 1.h,
             child: SafeArea(
              child: SizedBox(width: 100.w, child: ProfileUserData(user: user))
             )),
              /// Activities Background
              Positioned( top: 28.h,
                  child: InnerShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.7.h),
                    blur: 1.5.w,
                    child: Container( width: 100.w, height: 72.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.w),
                              topLeft: Radius.circular(12.w)
                          ),
                        )),
                  )),
              /// Ativities Widget
              Positioned( top: 28.h, child: Journal() ),
              ///Shadow
              Positioned( top: 2.h, left: 6.w,
                  child: Container( width: 88.w, height: 1.3.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.w),
                              topLeft:  Radius.circular(12.w)),
                          boxShadow: [  BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            offset: Offset(0, 1.5.h),
                            blurRadius: 4.w,
                          )]
                      ))
              ),
       ])
      ),
    );
  }
}

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({required this.user, Key? key}) : super(key: key);
  final MarvalUser user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: [
              /// Profile image
              SizedBox(width: 8.w),
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [kMarvalHardShadow],
                    borderRadius: BorderRadius.all(Radius.circular(100.w)),
                  ),
                  child: CircleAvatar(
                      backgroundColor: kBlack,
                      radius: 6.h,
                      backgroundImage:  isNullOrEmpty(user.profileImage) ?
                      null
                          :
                      Image.network(user.profileImage!, fit: BoxFit.fitHeight).image
                  )),
              SizedBox(width: 2.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h,),
                    TextH2('${user.name.clearSimbols()} ${user.lastName}', size: 4),
                    TextH2(user.work, size: 3, color: kGrey,),
                    TextH2(user.hobbie + ' y ' + user.favoriteFood, size: 3, color: kGrey,),
                  ]),
              SizedBox(width: 8.w,),
              Padding(padding: EdgeInsets.only(top: 4.5.h),
                  child: Icon(Icons.contact_page_rounded, color: kBlack, size: 14.w))
            ]),
        SizedBox(height: 1.5.h,),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BigLabel(data: user.initialWeight.toStringAsPrecision(3), text: 'Peso Inicial'),
          BigLabel(data: user.height.toInt().toString(), text: 'Altura'),
          BigLabel(data: user.age.toString(), text: 'Edad'),
        ])
      ]);
  }
}
class BigLabel extends StatelessWidget {
  const BigLabel({required this.data, required this.text, Key? key}) : super(key: key);
  final String data;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextH1(data, color: kGreen, size: 7,),
      TextH2(text, color: kBlack, size: 3,)
    ]);
  }
}



/// JOURNAL WIDGET
class Journal extends StatelessWidget {
  const Journal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
        String type = ref.watch(journalCreator);
        if(type == 'Diario'){
          return Diary();
        }else if(type == 'Habitos'){
          return HabitList();
        }
        return JournalList();
    });
  }
}

/// ACTIVITY LIST WIDGET */
List<String>   _labelNames = ['Diario', 'Habitos', 'Galeria', 'Medidas'];
List<IconData> _labelIcons = [Icons.event_note_rounded, CustomIcons.habits, CustomIcons.camera_retro, CustomIcons.tape];
class JournalList extends StatelessWidget {
  const JournalList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: _labelNames.length+1,
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
                        const TextH2("Revisa tu progreso", size: 4, color: kWhite,),
                      ]),
                );
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: JournalLabel(
                      text: _labelNames[index-1],
                      icon: _labelIcons[index-1],
                  ));
            }));
  }
}
class JournalLabel extends StatelessWidget {
  const JournalLabel({required this.text, required this.icon, Key? key}) : super(key: key);
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () => context.ref.update(journalCreator, (p0) => text),
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
              child: Center(child: Icon(icon, color: kWhite, size: 7.w,),),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    color: kBlueSec,
                    borderRadius: BorderRadius.circular(3.w)
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextH2(text, color: kWhite, size: 4.2),
                )
            ),
          ],
        ));
  }
}

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

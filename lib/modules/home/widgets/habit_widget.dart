import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/habits/dto/habits_resume.dart';

import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/utils/marval_arq.dart';

import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';

import 'package:marvalfit/widgets/marval_dialogs.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';



HomeController _controller = HomeController();
/// Habits WIDGETS */
class MarvalHabit extends StatelessWidget {
  const MarvalHabit({required this.habit, required this.active, required this.ref, required this.daily,  Key? key}) : super(key: key);
  final HabitsResumeDTO habit;
  final bool active;
  final Ref ref;
  final Daily daily;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: (){
          MarvalDialogsInfo(context, 40,
              title: habit.name,
              richText: RichText(
                text: TextSpan(text: habit.description,
                    style: TextStyle( fontFamily: p2,
                        fontSize: 4.5.w,
                        color: kBlack
                    )
                ),
              ));
        }, child:    Container( width: 33.w,
        decoration: BoxDecoration(
            color: kBlack,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(7.w),
                bottomLeft:  Radius.circular(7.w),
                bottomRight:  Radius.circular(7.w)
            )),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextH1(habit.label ?? '', size: 3.8, color: kWhite,),
                        SizedBox(width: 1.w,)
                      ]),
                  SizedBox(height: 1.5.h,),
                  GestureDetector(
                      onTap:() => _controller.updateHabit(ref, daily, habit.name),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.w),
                              border: Border.all(width: 0.7.w, color: kWhite),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.8),
                                  offset: Offset(0, 0.6.h),
                                  blurRadius: 3.1.w,
                                ),
                              ]),
                          child:  CircleAvatar(
                            radius: 4.w,
                            //@TODO Change kGrey with dark blue from date
                            backgroundColor:  isNull(Daily) ? kGrey : active ? kGreen : kGrey,
                          )
                      ))
                ])
        )));
  }
}
class MarvalHabitList extends StatelessWidget {
  const MarvalHabitList({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(width: 2.w,),
            Icon(CustomIcons.habits, size: 6.w, color: kGreen,),
            const TextH2("  Innegociables", size: 4,),
          ]),
          SizedBox(height: 2.h,),
          SizedBox(width: 100.w, height: 16.h,
              child:
              Watcher((context, ref, child) {
                Daily daily = _controller.getDaily(ref);
                final observer = _controller.hasChange(ref);
                return ListView.builder(
                    itemCount: daily.habitsFromPlaning.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          child: MarvalHabit(
                            habit: daily.habitsFromPlaning[index],
                            active: daily.habits.contains(daily.habitsFromPlaning[index].name),
                            daily: daily,
                            ref: ref,
                          ));
                    });
              })
          )
        ]);
  }
}



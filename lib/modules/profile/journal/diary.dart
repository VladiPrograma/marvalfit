import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/modules/profile/widgets/journal_title_row.dart';
import 'package:marvalfit/widgets/load_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/constants/global_variables.dart';

ScrollController _scrollController(Ref ref, int size){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){dailyLogic.fetchMore(ref, size);}});
  return res;
}

class Diary extends StatelessWidget {
  const Diary({ required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return  Watcher((context, ref, child) {
        final List<Daily> dailys = dailyLogic.get(ref, userId);
        final bool hasMoreData = dailyLogic.hasMore(ref);
        return SizedBox(width: 100.w, height: 72.h,
            child: ListView.separated(
              controller: _scrollController(ref, dailys.length),
              itemCount: hasMoreData ? dailys.length+2 : dailys.length + 1,
              itemBuilder: (context, index){
                if(index==0){ return const JournalTitle(name: "Apuntes diarios"); }
                if(index == dailys.length+1 && hasMoreData){ return const  LoadIndicator(); }
                return Container(margin: EdgeInsets.symmetric(horizontal: 12.w), child: _DiaryEntry(daily: dailys[index-1]));
              },
              separatorBuilder: (context, index) => SizedBox(height: 3.h,),
            ));
      });
  }
}

class _DiaryEntry extends StatelessWidget {
  const _DiaryEntry({required this.daily, Key? key}) : super(key: key);
  final Daily daily;
  @override
  Widget build(BuildContext context) {
    String aestheticDate = '${daily.date.day} ${daily.date.toStringMonth().toLowerCase()} ${daily.date.year}';
    NumberFormat numberFormat = NumberFormat("###,###,###");
    return Container(width: 95.w,
    padding: EdgeInsets.all(3.w),
    decoration: BoxDecoration(
      boxShadow: [BoxShadow(
        offset: Offset(0, 3.w),
        color: kBlackSec,
        blurRadius: 4.w
      )],
      color: kBlack,
      borderRadius: BorderRadius.circular(2.w)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Title
        Row(children: [TextH2(daily.date.toStringWeekDayLong(), color: kWhite, size: 3.8), const Spacer(), TextH2(aestheticDate, color: kWhite, size: 3.8)],),
        SizedBox(height: 0.7.h,),
        // Sleep & Weight
        Row(children: [
          Icon(CustomIcons.moon_inv, color: daily.sleep>0 ? kBlue : kBlackSec, size: 6.w,),
          Icon(CustomIcons.moon_inv, color: daily.sleep>1 ? kBlue : kBlackSec, size: 6.w,),
          Icon(CustomIcons.moon_inv, color: daily.sleep>2 ? kBlue : kBlackSec, size: 6.w,),
          Icon(CustomIcons.moon_inv, color: daily.sleep>3 ? kBlue : kBlackSec, size: 6.w,),
          Icon(CustomIcons.moon_inv, color: daily.sleep>4 ? kBlue : kBlackSec, size: 6.w,),
          const Spacer(),
          TextH2('${daily.weight} Kg', color: kWhite, size: 3.8,)
        ]),
        SizedBox(height: 0.7.h,),
        // Habits
        Wrap(
         spacing: 2.w,
         runSpacing: 0.7.h,
         children: daily.habitsFromPlaning.map((habit) =>
           TextH2(habit.label,
             color: daily.habits.contains(habit.label) ? kWhite : kGrey,
             size: 3.8
           )
         ).toList(),
        ),
        SizedBox(height: 0.7.h,),
        // Steps
        Wrap(
          spacing: 2.w,
          runSpacing: 0.7.h,
          children: daily.cardio.map((cardio) =>
              TextH2(
              '${cardioNames[cardio.type]!.getIcon()} ${cardio.num} ${cardioMeasureNames[cardio.measure]}',
                color: kWhite,
                size: 3.8,)
          ).toList(),
        ),
        SizedBox(height: 0.7.h,),
        //@TODO Fatsecret and Gym integration
        Row(children: const [
          TextH2('120🍗  80🍝  55🥑 ', color: kWhite, size: 3.8,),
          Spacer(),
          TextH2('1350 kcal', color: kWhite, size: 3.8,),
        ]),
    ]));
  }
}




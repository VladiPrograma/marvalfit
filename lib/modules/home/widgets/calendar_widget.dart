import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

HomeController _controller = HomeController();
class CalendarTitle extends StatelessWidget {
  const CalendarTitle({required this.date, Key? key}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Container(width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
        child: SafeArea(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () async{
                       DateTime newDate = date.add(const Duration(days: -7)).nextSaturday();
                      _controller.updateCalendar(context.ref, newDate);
                    },
                    child:Row(children:
                    [
                      Icon(Icons.arrow_back, color: kWhite, size: 6.w,),
                    ])),
                const Spacer(),
                TextH1(date.toStringMonth(), color: kWhite, size: 5),
                const Spacer(),
                GestureDetector(
                    onTap: () async{
                       DateTime newDate = date.add(const Duration(days: 7));
                       if(newDate.isBefore(DateTime.now())){
                         _controller.updateCalendar(context.ref, newDate);
                       }else{
                         //@TODO Add Errors Snackbar
                         logError('U cant go to the future');
                       }

                    },
                    child: Row(children: [
                      Icon(Icons.arrow_forward, color: kWhite, size: 6.w,),
                    ])),
              ]),
        ));
  }
}

/// CALENDAR WIDGETS */
class DateList extends StatelessWidget {
  const DateList({required this.date,  Key? key}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    DateTime monday =  date.lastMonday();
    return SizedBox(width: 100.w, height: 10.h,
          child: ListView.builder(
              itemCount: 7, // Week Days
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                DateTime day =  monday.add(Duration(days: index));
                return Container(
                    margin: EdgeInsets.only(right: 2.3.w),
                    child: DateCell(date: day, selected: day.isSameDate(date))
                );
              }));
  }
}

class DateCell extends StatelessWidget {
  const DateCell({required this.date, required this.selected,  Key? key}) : super(key: key);
  final DateTime date;
  final bool selected;
  @override
  Widget build(BuildContext context) {
      return GestureDetector(
          onTap: ()  {
            if(!date.isAfter(DateTime.now())){
              _controller.updateCalendar(context.ref, date);
            }
            //@TODO change Snackbar
            // else if(_snackCounter==0){ ThrowSnackbar.nextWeekError(context); _snackCounter++;}
          },
          child:  Container(width: 11.w, height: 11.h,
            decoration: BoxDecoration(
              color:  selected ? kGreen :
              date.isAfter(DateTime.now()) ? kBlack.withOpacity(0.6) : kBlack,
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextH2("${date.day}", color: kWhite, size: 4,),
                  TextH2(date.toStringWeekDay(),color: kWhite, size: 3,)
                ]),
          )
      );}
}
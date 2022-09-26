import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../config/log_msg.dart';
import '../../config/custom_icons.dart';
import '../../modules/home/journal.dart';

import '../../constants/colors.dart';
import '../../constants/shadows.dart';
import '../../constants/global_variables.dart';
import '../../constants/string.dart';
import '../../constants/theme.dart';

import '../../utils/extensions.dart';
import '../../utils/decoration.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';

import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_drawer.dart';
import '../../widgets/marval_snackbar.dart';

import 'logic.dart';

ScrollController _controller = ScrollController();
void snackBarAlert(BuildContext context){
  return    MarvalSnackBar(context, SNACKTYPE.alert,
      title: 'Esta prohibido viajar al futuro',
      subtitle: 'Lo pasado ha huido, lo que esperas está ausente, pero el presente es tuyo.');
}
int _snackCounter = 0;

///@TODO Add methods to remove al the "context.ref.watch...."
///@TODO Animation on date change.
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MarvalDrawer(page: "Home",),
        backgroundColor: kWhite,
        body:  SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          child: SizedBox( width: 130.w, height: 124.h,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ///Active User
                    Watcher((context, ref, child) {
                      watchActiveUser(context, ref);
                      return const SizedBox.shrink();
                    }),
                    Container(width: 100.w, height: 124.h,
                        color: kWhite,
                        child:  Stack( children: [
                          /// Calendar Background
                          Positioned( top: 0,
                              child: Container(width: 100.w, height: 26.h,
                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  decoration: BoxDecoration(
                                    color: kBlue,
                                    boxShadow: [kMarvalBoxShadow],
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.w)),
                          ))),
                          /// Calendar Arrows
                          Positioned(
                            top: 0,
                            child: Container(width: 100.w,
                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                              child: SafeArea(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () async{
                                          DateTime date = context.ref.watch(weekCreator);
                                          date = date.add(const Duration(days: -7)).nextSaturday();
                                          logInfo(date.id);
                                          logInfo(user.startDate);
                                          if(!date.isBefore(user.startDate)){
                                            context.ref.update<DateTime>(weekCreator, (date) => date.add(const Duration(days: -7)));
                                            await Future.delayed(const Duration(milliseconds: 100));
                                            context.ref.update<DateTime>(dateCreator, (date) => context.ref.watch(weekCreator).nextSaturday());
                                            createDailyIfDoNotExists(context.ref.watch(dateCreator));
                                          }
                                        },
                                        child:Row(children:
                                        [
                                          Icon(Icons.arrow_back, color: kWhite, size: 6.w,),
                                          const TextH2(' Anterior', color: kWhite, size: 4,)
                                        ])),
                                    const Spacer(),

                                    Watcher((context, ref, child){
                                      DateTime date =ref.watch(dateCreator);
                                      return TextH1(date.toStringMonth(), color: kWhite, size: 7.5);
                                    }),
                                    const Spacer(),
                                    GestureDetector(
                                        onTap: () async{
                                          DateTime nextWeek = context.ref.watch(weekCreator).add(const Duration(days: 7));
                                          logInfo(nextWeek.id);
                                          if(!nextWeek.isAfter(DateTime.now())){
                                            context.ref.update<DateTime>(weekCreator, (date) => date.add(const Duration(days: 7)));
                                            await Future.delayed(const Duration(milliseconds: 50));
                                            context.ref.update<DateTime>(dateCreator, (date) => context.ref.watch(weekCreator));
                                            createDailyIfDoNotExists(context.ref.watch(dateCreator));
                                          }else if(_snackCounter==0){ snackBarAlert(context); _snackCounter++;}

                                        },
                                        child: Row(children: [
                                          const TextH2('Siguiente ', color: kWhite, size: 4,),
                                          Icon(Icons.arrow_forward, color: kWhite, size: 6.w,),
                                        ])),
                                  ]),
                            )),
                          ),
                          /// Date List
                          Positioned(
                            top: 8.h,
                            left: 6.w,
                            child: Container( width: 100.w,
                            margin: EdgeInsets.only(top: 4.h),
                            child: const Center(child: DateList()),
                          )),
                          /// Little Box to make blue Right Margin
                          Positioned(right: 0, top: 25.h,
                              child: Container(width: 20.w, height: 10.h, color: kBlue
                              )),
                          Positioned(right: 0, top: 26.h,
                              child: Container(width: 20.w, height: 50.h,
                                  decoration: BoxDecoration(
                                      color: kBlue,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(15.w))
                                  ),
                                  child: InnerShadow(
                                      color: kBlack.withOpacity(0.45),
                                      offset: Offset(0, 0.7.h),
                                      blur: 1.5.w,
                                      child:
                                      Container(
                                          decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.only(topRight:  Radius.circular(12.w)),
                                            color: kWhite,
                                          )))
                              )),
                          /// Weight & Sleep Widgets
                          Positioned(top: 28.h,
                              child: Container( width: 100.w, height: 20.h,
                                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                                  child: Row( children:[
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row( children: [
                                            Icon(CustomIcons.fitness, size: 7.w, color: kGreen,),
                                            const TextH2("  Sueño y Peso", size: 4,),
                                          ]),
                                          const MoonList(),
                                        ]),
                                    const Spacer(),
                                    MarvalWeight()
                                  ])
                              )),
                          /// Habits Row
                          Positioned(top: 44.h, child: const MarvalHabitList() ),
                          /// Activities Background
                          Positioned( top: 66.5.h,
                              child: InnerShadow(
                                color: Colors.black,
                                offset: Offset(0, 0.7.h),
                                blur: 1.5.w,
                                child: Container( width: 100.w, height: 59.h,
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
                          Positioned( top: 66.5.h,
                              child: Journal(controller: _controller,)
                          ),
                          Positioned( top: 65.5.h, left: 6.w,
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
                  ])),
        ));
  }
}

double _sleekInit= 0;
class MarvalWeight extends StatelessWidget {
  const MarvalWeight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
        radius: 17.w,
        child:Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.w)),
              color: kBlack,
            ),
            child: Watcher((context, ref, child) {
              Daily? daily = getDaily(ref);
              double weight = isNull(daily) ?  3 :
              daily!.weight != 0 ? daily.weight : user.currWeight;
              return SleekCircularSlider (
                initialValue: _sleekInit,
                max: 2,
                min: -2,
                onChangeEnd: (value) {
                  ///* Firebase Updates */
                  if(isNotNull(daily)){
                    double newWeight =  double.parse((weight+value).toStringAsPrecision(3));
                    _sleekInit != 0 ? _sleekInit=0 : _sleekInit+=0.0001;
                    daily!.updateWeight(newWeight);
                    DateTime date = daily.date;
                    if(user.update.isBefore(date)||user.update.isSameDate(date)){
                      user.updateWeight(weight: newWeight, date: date);
                    }
                    else if(user.lastUpdate.isBefore(date)||user.lastUpdate.isSameDate(date)){
                      user.updateLastWeight(weight: newWeight, date: date);
                    }
                  }
                },
                appearance: CircularSliderAppearance(
                    size: 38.w,
                    startAngle: 215,
                    animationEnabled: true,
                    customColors: CustomSliderColors(
                        progressBarColor: kBlue,
                        trackColor: kBlueSec,
                        hideShadow: true,
                        dotColor: kWhite
                    ),
                    angleRange: 305,
                    customWidths: CustomSliderWidths(
                        trackWidth: 1.3.w,
                        progressBarWidth: 3.5.w,
                        handlerSize: 1.1.w
                    )

                ),
                innerWidget: (percentage) =>
                    Center( child:
                    TextH1( "${(weight+percentage).toStringAsPrecision(3)}\nKg",
                      color: kWhite,
                      size: 5.5,
                      textAlign: TextAlign.center,
                    )
                    ),

              );})));
  }
}

/// CALENDAR WIDGETS */
class DateCell extends StatelessWidget {
  const DateCell({required this.date, Key? key}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      return GestureDetector(
          onTap: ()  {
            if(!date.isAfter(DateTime.now())){
              ref.update(dateCreator, (d) => date);
              createDailyIfDoNotExists(date);
            }else if(_snackCounter==0){ snackBarAlert(context); _snackCounter++;}
          },
          child:  Container(width: 11.w, height: 11.h,
            decoration: BoxDecoration(
              color:  ref.watch(dateCreator).id == date.id ? kGreen :
              date.isAfter(DateTime.now()) ? kBlack.withOpacity(0.6) : kBlack,
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextH2("${date.day}", color: kWhite, size: 4,),
                  TextH2(date.toStringWeekDay(),color: kWhite, size: 3,)
                ]),
          ));}
    );
  }
}
class DateList extends StatelessWidget {
  const DateList({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      final weekDay = ref.watch(weekCreator);
      return SizedBox(width: 100.w, height: 10.h,
          child: ListView.builder(
              itemCount: 7, // Week Days
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                DateTime _day =  weekDay.add(Duration(days: index));
                return Container(
                    margin: EdgeInsets.only(right: 2.3.w),
                    child: DateCell(date: _day)
                );
              }));
    });
  }
}

/// Sleep Widget
class Moon extends StatelessWidget {
  const Moon({required this.num, Key? key}) : super(key: key);
  final int num;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      Daily? daily = getDaily(ref);
      return GestureDetector(
          onTap: () {
            if(isNotNull(daily)){
              if(daily!.sleep == 1) {  daily.updateSleep(0);  }
              else                  {  daily.updateSleep(num);}
            }
          },
          child: Icon(
              CustomIcons.moon_inv,
              size: 9.w,
              color: isNull(daily) ? kBlack : daily!.sleep < num ? kBlack : kBlue
          )
      );
    });

  }
}
class MoonList extends StatelessWidget {
  const MoonList({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 55.w, height: 10.h,
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(right: 2.3.w),
                  child:  Moon(num: index+1));
            })
    );
  }
}

///@TODO Add little info Icon for every habit
/// Habits WIDGETS */
class MarvalHabit extends StatelessWidget {
  const MarvalHabit({required this.habit, Key? key}) : super(key: key);
  final Map<String, dynamic>? habit;
  @override
  Widget build(BuildContext context) {
    if(isNull(habit)) return const SizedBox();
    return  Container( width: 33.w,
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
                        TextH1(habit?['label'] ?? '', size: 3.8, color: kWhite,),
                        SizedBox(width: 1.w,),
                        GestureDetector(
                            onTap: (){ MarvalDialogsInfo(context, 40,
                                title: habit?['name'] ?? '',
                                richText:RichText(
                                  text: TextSpan(text: habit?['description'],
                                      style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack)),
                                ));
                            },
                            child: Icon(CustomIcons.info, size: 3.w, color: kGreen,))
                      ]),
                  SizedBox(height: 1.5.h,),
                  GestureDetector(
                      onTap:(){
                        Daily? daily = getDaily(context.ref);
                        if(isNotNull(daily))  daily!.updateHabits(habit!['label']!);
                      },
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
                          child:  Watcher((context, ref, child) {
                            Daily? daily = getDaily(ref);
                            return CircleAvatar(
                              radius: 4.w,
                              backgroundColor:  isNull(Daily) ? kGrey :
                                  ///@TODO Change kGrey with dark blue from date
                              daily!.habits.contains(habit!['label']) ? kGreen : kGrey,
                            );
                          })
                      ))
                ])
        ));
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
                Daily? daily = getDaily(ref);
                if(isNull(daily)) return const SizedBox.shrink();
                return ListView.builder(
                    itemCount: daily?.habitsFromPlaning?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          child: MarvalHabit(habit: daily?.habitsFromPlaning?[index]));
                    });
              })
          )
        ]);
  }
}



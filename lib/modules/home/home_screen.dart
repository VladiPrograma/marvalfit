import 'dart:async';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../config/custom_icons.dart';
import '../../constants/global_variables.dart';
import '../../utils/decoration.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/planing.dart';
import '../../utils/objects/user.dart';
import '../../utils/objects/user_daily.dart';
import '../../widgets/marval_drawer.dart';

late Daily _daily;
late double _max, _min, _init, _perc; // Sleek Widget vars


///* @TODO Make the hole page using CREATOR
///* @TODO Add info icon to habits and display info Dialog on Tap.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    super.initState();
     user = MarvalUser.empty();
    _daily = Daily.create(date: DateTime.now(), habitsFromPlaning: [], activities: []);
    _init=0; _max=5; _min=-5; _perc=_init;
    // Create anonymous function:
    () async {

  /** Using async methods to fetch Data */
      user = await MarvalUser.getFromDB(authUser.uid);
      await user.getCurrentTraining();
      logInfo(user.currenTraining!.activities ?? 'No furula');
      _daily = await _onNewDate(DateTime.now());
      _updateSleep(context.ref, _daily.sleep);
      _init = _daily.weight == 0 ? user.currWeight : _daily.weight;
      _max=_init+2; _min=_init-2;  _perc=_init;
      setState(() {});
    }();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MarvalDrawer(name: "Home",),
      backgroundColor: kWhite,
      body:  SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox( width: 100.w, height: 124.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Watcher((context, ref, child) {
              watchActiveUser(context, ref);
              return const SizedBox();
            }),
             Container(width: 100.w, height: 124.h,
              color: kWhite,
              child:  Stack( children: [
                  /// Calendar Widget
                  Positioned( top: 0,
                    child: Container(width: 100.w, height: 26.h,
                     padding: EdgeInsets.all(4.w),
                     decoration: BoxDecoration(
                     color: kBlue,
                     boxShadow: [kMarvalBoxShadow],
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.w)),
                   ),
                   child: SafeArea(
                   child:Column( children: [
                  /// Calendar Arrows
                  Row(children: [
                    GestureDetector(
                    onTap: () {
                      Ref ref = context.ref;
                      final primal = _watchWeek(ref);
                      final date = primal.add(const Duration(days: -7));
                      _updateWeek(ref, date);
                      _onDateChange(ref, date.nextSaturday());
                    },
                    child:Row(children:
                      [
                      Icon(Icons.arrow_back, color: kWhite, size: 6.w,),
                      const TextH2(' Anterior', color: kWhite, size: 4,)
                    ])),
                    const Spacer(),
                    Watcher((context, ref, child){
                      final primal = _watchWeek(ref);
                      return TextH1(primal.toStringMonth(), color: kWhite, size: 7.5,);
                    }),
                    const Spacer(),
                    GestureDetector(
                    onTap: () {
                      Ref ref = context.ref;
                      final primal = _watchWeek(ref);
                      final date = primal.add(const Duration(days: 7));
                      _updateWeek(ref, date);
                      _onDateChange(ref, date.lastMonday());
                    },
                    child: Row(children: [
                      const TextH2('Siguiente ', color: kWhite, size: 4,),
                      Icon(Icons.arrow_forward, color: kWhite, size: 6.w,),
                    ])),
                   ]),
                   SizedBox(height: 1.h,),
                   DateList(),
                   ]),
                  ))),
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
                     Watcher((context, ref, child){
                       _watchDate(ref);
                       return MarvalWeight();
                     })

                    ])
                  )),
                  /// Habits Row
                  Positioned(top: 44.h,
                      ///@TODO if we change to a date with other habits??
                      child: MarvalHabitList(data: user.currenTraining?.habits!,)),
                  /// _activities Row
                  Positioned( top: 66.5.h,
                      child: InnerShadow(
                        color: Colors.black,
                        offset: Offset(0, 0.7.h),
                        blur: 1.5.w,
                        child: Container( width: 100.w, height: 59.h,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(12.w), topLeft: Radius.circular(12.w)),
                                color: kBlack
                            )),
                      )),
                  /// _activities Widget
                  Positioned( top: 66.5.h,
                      child: Container( width: 100.w, height: 34.5.h,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: MarvalActivityList(activities: _daily.activities,)
                      )),
                  Positioned( top: 65.5.h, left: 6.w, child:
                  Container( width: 88.w, height: 1.3.h,
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
                  ))),
                ])
            ),
          ])),
    ));
  }
}

/// SLIDER WIDGET */
class MarvalWeight extends StatefulWidget {
  const MarvalWeight({ Key? key}) : super(key: key);
  @override
  State<MarvalWeight> createState() => _MarvalWeightState();
}
class _MarvalWeightState extends State<MarvalWeight>{
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 17.w,
        child:Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.w)),
              color: kBlack,
            ),
            child: SleekCircularSlider (
                min: _min,
                max: _max,
                initialValue: _init,
                onChangeEnd: (value) async{
                  _perc = double.parse(value.toStringAsPrecision(3));
                   logInfo(_perc.toString());
                  _max+=_perc-_init;
                  _min+=_perc-_init;
                  ///* Setting Half Data For SetState x2 */
                  setState(() { });
                  await Future.delayed(const Duration(milliseconds: 100));
                  _init= (_max+_min)/2;
                  setState(() {  });
                  ///* Firebase Updates */
                  _daily.updateWeight(_perc);
                  DateTime date = _watchDate(context.ref);
                  if(user.update.isBefore(date)||user.update.isSameDate(date)){
                    user.updateWeight(weight: _perc, date: date);
                  }
                  else if(user.lastUpdate.isBefore(date)||user.lastUpdate.isSameDate(date)){
                    user.updateLastWeight(weight: _perc, date: date);
                  }
                },
                appearance: CircularSliderAppearance(
                    size: 38.w,
                    startAngle: 215,
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
                    TextH1( "${_perc.toStringAsPrecision(3)}\nKg",
                      color: kWhite,
                      size: 5.5,
                      textAlign: TextAlign.center,
                    )
                ),
                onChange: (double value) {
                  _perc = value;
                }
            )));
  }
}

/// Calendar Logic*/
Creator<DateTime> _dateCreator = Creator.value(DateTime.now());
DateTime _watchDate(Ref ref) => ref.watch(_dateCreator);
void _updateDate(Ref ref, DateTime  date) => ref.update(_dateCreator, (d) => date);

Creator<DateTime> _weekCreator = Creator.value(DateTime.now().lastMonday());
DateTime _watchWeek(Ref ref) => ref.watch(_weekCreator);
void _updateWeek(Ref ref, DateTime  date) => ref.update(_weekCreator, (d) => date);

/// CALENDAR WIDGETS */
class DateCell extends StatelessWidget {
  const DateCell({required this.date, Key? key}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async => await _onDateChange(context.ref, date),
        child: Watcher((context, ref, child) {
          final primal = _watchDate(ref);
          return Container(width: 11.w, height: 11.h,
              decoration: BoxDecoration(
              color:  primal.day == date.day ? kGreen : kBlack,
              borderRadius: BorderRadius.circular(12.w),
              ),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextH2("${date.day}", color: kWhite, size: 4,),
              TextH2(date.toStringWeekDay(),color: kWhite, size: 3,)
            ]),
          );}
        ));
  }
}
class DateList extends StatelessWidget {
  const DateList({ Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  SizedBox(width: 100.w, height: 10.h, child:
    Watcher((context, ref, child) {
      final primal = _watchWeek(ref);
      return ListView.builder(
          itemCount: 7, // Week Days
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            DateTime _day =  primal.add(Duration(days: index));
            return Container(
                margin: EdgeInsets.only(right: 2.3.w),
                child: DateCell(date: _day));
          });
    }));
  }
}

///* Date FUNCTIONS */
Future<Daily> _onNewDate(DateTime date) async{
  String key = date.id;
  if(user.dailys!.containsKey(key)){
    ///@TODO Change this hardcoded fix
    await Future.delayed(const Duration(milliseconds: 100));
    return user.dailys![key]!;
  }

  else if(await Daily.existsInDB(date)){

    await user.getDaily(date);
    return user.dailys![key]!;

  }else{
    user.dailys![key] = Daily.create(
        date: date,
        habitsFromPlaning: user.currenTraining!.habits ?? [],
        activities: user.currenTraining!.activities ?? []);
    user.dailys![key]!.setInDB();
    return user.dailys![key]!;
  }
}
Future<void> _onDateChange(Ref ref, DateTime date) async{

  _daily = await _onNewDate(date);
  _updateDate(ref, date);
   logSuccess(_watchDate(ref).id);
  _updateSleep(ref, _daily.sleep);
  ///@TODO If daily_weight isn't load ?
  _init = _daily.weight == 0 ? user.currWeight : _daily.weight;
  _max=_init+2; _min=_init-2;  _perc=_init;
}

/// Sleep Logic */
Creator<int> _sleepCreator = Creator.value(0);
int _watchSleep(Ref ref) => ref.watch(_sleepCreator);
void _updateSleep(Ref ref, int  num) => ref.update(_sleepCreator, (moon) => num);

/// Sleep Widget
class Moon extends StatelessWidget {
  const Moon({required this.num, Key? key}) : super(key: key);
  final int num;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Ref ref = context.ref;
        int n = _watchSleep(ref);
        if( num == 1 && n == 1){
          _updateSleep(ref, 0);
        }else {
          _updateSleep(ref, num);
        }
        _daily.updateSleep(_watchSleep(ref));
        logInfo("Moon Tapped ${_watchSleep(ref)}/5");
       },
      child: Watcher((context, ref, child) {
        int moons = _watchSleep(ref);
        return Icon(CustomIcons.moon_inv, size: 9.w, color:  moons < num ? kBlack : kBlue);
      })
    );
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

/// Habits Logic */
Creator<bool> habitsCreator = Creator.value(true);
void updateHabits(Ref ref) => ref.update<bool>(habitsCreator, (b) => !b);

/// Habits WIDGETS */
class MarvalHabit extends StatelessWidget {
  const MarvalHabit({required this.text, Key? key}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
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
                TextH1(text, size: 3.8, color: kWhite,),
                SizedBox(height: 1.5.h,),
                GestureDetector(
                    onTap:(){
                      _daily.updateHabits(text);
                      updateHabits(context.ref);
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
                          final primal = _watchDate(ref);
                          final reload = ref.watch(habitsCreator);
                          String key = primal.id;
                          List<String>? habits = user.dailys?[key]?.habits;
                          bool flag = false;
                          if(isNotNull(habits) && habits!.contains(text)){ flag = true; }
                          return CircleAvatar(
                            backgroundColor:  flag ? kGreen : kGrey  ,
                            radius: 4.w,
                          );
                        })))
              ])),
    );
  }
}
///@TODO Add little info Icon for every habit
class MarvalHabitList extends StatelessWidget {
   const MarvalHabitList({ this.data, Key? key}) : super(key: key);
   final List<String>? data;
   @override
   Widget build(BuildContext context) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children:
       [
         Row(children:
         [
           SizedBox(width: 2.w,),
           Icon(CustomIcons.habits, size: 6.w, color: kGreen,),
           const TextH2("  Innegociables", size: 4,),
         ]),
         SizedBox(height: 2.h,),
         SizedBox(width: 100.w, height: 16.h,
           child: ListView.builder(
           itemCount: data?.length ?? 0,
           scrollDirection: Axis.horizontal,
           itemBuilder: (context, index) {
             return Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              child: MarvalHabit(text: data![index]));
           }))
       ]);
   }
 }

/// Activities WIDGET */
Creator<bool> _activitiesCreator = Creator.value(true);
void _updateActivities(Ref ref) => ref.update<bool>(_activitiesCreator, (b) => !b);
class MarvalActivity extends StatelessWidget {
  const MarvalActivity({required this.activity, Key? key}) : super(key: key);
  final Map<String, dynamic>? activity;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
          activity?['reference'] = authUser.uid + activity?['id'];
          _updateActivities(context.ref);
          logInfo(_daily.activities);
        },
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
              child: Center(child: Icon(mapIcons[activity?['icon']] ?? mapIcons[''], color: kWhite, size: 7.w,),),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                  color: kBlueSec,
                  borderRadius: BorderRadius.circular(3.w)
              ),
              child: Row(
                  children: [
                    TextH2(activity?['label'] ?? '', color: kWhite, size: 4.2,),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.w),
                            border: Border.all(
                                width: 0.4.w,
                                color: kWhite
                            )
                        ),
                        child:Watcher((context, ref, child) {
                          ref.watch(_activitiesCreator);
                          return CircleAvatar(
                            backgroundColor: isNull(activity?['reference'])  ?  kBlack : kBlue,
                            radius: 1.8.w,
                          );
                        }))
                  ]),
            ),
          ],
        ));
  }
}

class MarvalActivityList extends StatelessWidget {
  const MarvalActivityList({required this.activities, Key? key}) : super(key: key);
  final List<Map<String, dynamic>>? activities;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
       itemCount: isNull(activities) ? 1 : activities!.length+1,
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
                   const TextH2(" Completa tus tareas", size: 4, color: kWhite,),
                 ]),
           );
         }
         return Container(
             margin: EdgeInsets.only(bottom: 1.5.h),
             child: MarvalActivity(activity: activities?[index-1] ?? {},));
       });
  }
}

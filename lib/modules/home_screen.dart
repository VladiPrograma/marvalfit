import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../config/custom_icons.dart';
import '../constants/global_variables.dart';
import '../constants/string.dart';
import '../utils/decoration.dart';
import '../utils/marval_arq.dart';
import '../utils/objects/user.dart';
import '../widgets/marval_dialogs.dart';
import '../widgets/marval_drawer.dart';
import '../widgets/marval_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

///@TODO Main page Logic when is Logged but he doesnt complete de forms.

final habits = ["Frio", "Naturaleza", "Agradecer", "Sol", "Caminar"];
final activities = ["Descanso", "Medidas", "Galeria", "Push", "Pull", "Pierna I", "Pierna II"];
final activities_icons = [CustomIcons.bed, CustomIcons.tape, CustomIcons.camera, CustomIcons.lifting, CustomIcons.lifting_2, CustomIcons.leg, CustomIcons.leg];
class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState(){
    super.initState();
    if(isNull(dateNotifier)){ dateNotifier = ValueNotifier(DateTime.now()); }

  // Create anonymous function:
    () async {
  /** Using async methods to fetch Data */
      user = await MarvalUser.getFromDB(authUser!.uid);
      user!.getCurrentTraining();

      logInfo(user.toString());
      setState(() {});
    }();
  }

  @override
  void dispose() {
    dateNotifier!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MarvalDrawer(name: "Home",),
      backgroundColor: kWhite,
      body:  SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container( width: 100.w, height: 124.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Container(width: 100.w, height: 124.h, color: kWhite,
              child:  Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(width: 100.w, height: 26.h,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                          color: kBlue,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.w)),
                          boxShadow: [kMarvalBoxShadow]
                      ),
                      child: SafeArea(
                        child:Column(
                          children: [
                            Row(children: [
                              GestureDetector(
                                  onTap: (){
                                    dateNotifier!.value = dateNotifier!.value.add(Duration(days: -7));
                                    setState(() {});
                                  },
                                  child:Container(
                                      child: Row(children: [
                                        Icon(Icons.arrow_back, color: kWhite, size: 6.w,),
                                        TextH2(' Anterior', color: kWhite, size: 4,)
                                      ]))),
                              Spacer(),
                              TextH1(dateNotifier!.value.toStringMonth(), color: kWhite, size: 7.5,),
                              Spacer(),
                              GestureDetector(
                                  onTap: (){
                                      dateNotifier!.value = dateNotifier!.value.add(Duration(days: 7));
                                    setState(() {});
                                  },
                                  child:Container(
                                      child: Row(children: [
                                        TextH2('Siguiente ', color: kWhite, size: 4,),
                                        Icon(Icons.arrow_forward, color: kWhite, size: 6.w,),
                                      ]))),
                            ]),
                            SizedBox(height: 1.h,),
                            ValueListenableBuilder(
                              valueListenable: dateNotifier!,
                              builder: (context, value, child) {
                                return DateList(startDate: dateNotifier!.value,);
                              },
                            )
                          ],
                        ),
                      )),),
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
                              offset: Offset(0, 1.4.w),
                              blur: 1.5.w,
                              child: Container(
                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.only(topRight:  Radius.circular(12.w)),
                                    color: kWhite,
                                  ))))),
                  /// Weight & Sleep Widgets
                  Positioned(top: 28.h,
                      child: Container(
                        width: 100.w,
                        height: 20.h,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Row(
                            children:[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row( children: [
                                    Icon(CustomIcons.fitness, size: 7.w, color: kGreen,),
                                    TextH2("  Sueño y Peso", size: 4,),
                                  ]),
                                  MoonList(),
                                ]),
                              Spacer(),
                              isNull(user) ? Text("") : MarvalWeight(initialValue: user!.currWeight),
                            ]),
                      )),
                  /// Habits Row
                  Positioned(top: 44.h,
                      child: MarvalHabitList()),
                  /// Activities Row
                  Positioned( top: 66.5.h,
                    child: InnerShadow(
                    color: Colors.black,
                    offset: Offset(0, 1.4.w),
                    blur: 1.5.w,
                    child: Container( width: 100.w, height: 59.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(12.w), topLeft: Radius.circular(12.w)),
                            color: kBlack
                        )),
                    )),
                  /// Activities Widget
                  Positioned( top: 66.5.h,
                      child: Container( width: 100.w, height: 34.5.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                         child: MarvalActivityList()
                      )),

                  Positioned( top: 65.5.h, left: 6.w,
                    child:  Container( width: 88.w, height: 1.3.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(12.w), topLeft: Radius.circular(12.w)),
                            color: Colors.transparent,
                            boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              offset: Offset(0, 4.w),
                              blurRadius: 4.w,
                            )]
                        )),
                  ),
            ])),
          ],
        )),
    ));
  }
}

/// SLIDER WIDGET */
class MarvalWeight extends StatelessWidget {
  const MarvalWeight({required this.initialValue, Key? key}) : super(key: key);
  final double initialValue;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 18.w,
        child:Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.w)),
              color: kBlack,
            ),
            child: SleekCircularSlider(
                min: initialValue-4,
                max: initialValue +4,
                initialValue: initialValue,
                onChangeEnd: (value) {
                  ///@TODO Save weight data to Firebase
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
                innerWidget: (percentage) =>   Center(
                        child: TextH1(
                          "${percentage.toStringAsPrecision(3)}\nKg",
                          color: kWhite,
                          size: 5.5,
                          textAlign: TextAlign.center,
                        )
                    ),
                onChange: (double value) {
                  ///@TODO move this dialog to "onChangeEnd" then modify the Dialog to set Max and Min values.
                  if(value == initialValue+4||value == initialValue-4){
                    RichText _richText = RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        text: "Si el correo se encuentra dado de alta se enviará un ",
                        style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                        children: const <TextSpan>[
                          TextSpan(
                              text:  " correo de inmediato",
                              style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                              text:" desde el que podra restablecer su contraseña."
                          ),
                        ],
                      ),
                    );
                    GlobalKey<FormState> _formKey = GlobalKey();
                    Form _form = Form(
                      key: _formKey,
                      child: MarvalInputTextField(
                        labelText: 'Email',
                        hintText: "marvalfit@gmail.com",
                        prefixIcon: CustomIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(isNullOrEmpty(value)){
                            return kInputErrorEmptyValue;
                          }if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)){
                            return kInputErrorEmailMissmatch;
                          }
                          return null;
                        },
                        onSaved: (value){ },
                      ),
                    );
                    MarvalDialogsInput(context,
                        title: "Recuperar contraseña",
                        height: 48,
                        form: _form,
                        richText: _richText,
                        onSucess: (){ }
                    );
                  }
                })));
  }
}



/// CALENDAR WIDGETS */
class DateList extends StatefulWidget {
  const DateList({required this.startDate, Key? key}) : super(key: key);
  final DateTime startDate;
  @override
  State<DateList> createState() => _DateListState();
}
class _DateListState extends State<DateList> {
  @override
  Widget build(BuildContext context) {
     DateTime _lastMonday = widget.startDate.lastMonday();
    return  Container(width: 100.w, height: 10.h, child:
    ListView.builder(
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
           DateTime _day =  _lastMonday.add(Duration(days: index));
          return Container(
              margin: EdgeInsets.only(right: 2.3.w),
              child: DateCell(date: _day));
        }));
  }
}

class DateCell extends StatelessWidget {
  const DateCell({required this.date, Key? key}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          dateNotifier!.value = date;
        },
        child: Container(width: 11.w, height: 11.h,
          decoration: BoxDecoration(
            color:  dateNotifier!.value.day == date.day ? kGreen : kBlack,
            borderRadius: BorderRadius.circular(12.w),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextH2("${date.day}", color: kWhite, size: 4,),
              TextH2(date.toStringWeekDay(),color: kWhite, size: 3,)

            ],),
        ));
  }
}


/// Sleep WIDGETS */
late ValueNotifier<int> _sleepNotifier;

class Moon extends StatelessWidget {
  const Moon({required this.num, Key? key}) : super(key: key);
  final int num;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if( num == 1 && _sleepNotifier.value == 1){
          _sleepNotifier.value = 0;
        }else {
          _sleepNotifier.value = num;
        }
        logSuccess("Moon Tapped ${_sleepNotifier.value}, Widget Num: $num");
       },
      child: Icon(CustomIcons.moon_inv, size: 9.w, color:  _sleepNotifier.value < num ? kBlack : kBlue)
    );
  }
}

class MoonList extends StatefulWidget {
  const MoonList({Key? key}) : super(key: key);

  @override
  State<MoonList> createState() => _MoonListState();
}
class _MoonListState extends State<MoonList> {

  @override
  void initState() {
    super.initState();
    _sleepNotifier = ValueNotifier(0);
  }
  @override
  void dispose() {
    _sleepNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _sleepNotifier,
      builder: (context, value, child) {
        return Container(width: 55.w, height: 10.h, child:
        ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                  margin: EdgeInsets.only(right: 2.3.w),
                  child: Moon(num: index+1));
            }));
      },
    );


  }
}

/// Habits WIDGETS */
class MarvalHabit extends StatefulWidget {
  const MarvalHabit({required this.name, Key? key}) : super(key: key);
  final String name;
  @override
  State<MarvalHabit> createState() => _MarvalHabitState();
}
class _MarvalHabitState extends State<MarvalHabit> {
  @override
  bool _done = false;
  Widget build(BuildContext context) {
    return  Container( width: 33.w,
        decoration: BoxDecoration(
          color: kBlack,
          borderRadius: BorderRadius.only(topRight: Radius.circular(7.w), bottomLeft:  Radius.circular(7.w), bottomRight:  Radius.circular(7.w)),
        ),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextH1(widget.name, size: 3.8, color: kWhite,),
            SizedBox(height: 1.5.h,),
            GestureDetector(
              onTap:() => setState(() => _done = !_done ),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    offset: Offset(0, 1.3.w),
                    blurRadius: 3.1.w,
                  )],
                  borderRadius: BorderRadius.circular(100.w),
                  border: Border.all(
                    width: 0.7.w,
                    color: kWhite
                  )
                ),
              child: CircleAvatar(
                backgroundColor: _done ? kGreen : kGrey,
                radius: 4.w,
            )))
          ])),
        );
  }
}

class MarvalHabitList extends StatelessWidget {
   const MarvalHabitList({Key? key}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row( children: [
           SizedBox(width: 2.w,),
           Icon(CustomIcons.habits, size: 6.w, color: kGreen,),
           TextH2("  Innegociables", size: 4,),
         ]),
         SizedBox(height: 2.h,),
         Container(width: 100.w, height: 16.h,
           child: ListView.builder(
               itemCount: 5,
               scrollDirection: Axis.horizontal,
               itemBuilder: (context, index) {
                 return Container(
                     margin: EdgeInsets.symmetric(horizontal: 2.w),
                     child: MarvalHabit(name: habits[index]));
               }),)
       ],
     );
   }
 }

 /// Activities WIDGET */

class MarvalActivity extends StatefulWidget {
  const MarvalActivity({required this.icon, required this.title, Key? key}) : super(key: key);
  final IconData icon;
  final String title;
  @override
  State<MarvalActivity> createState() => _MarvalActivityState();
}
class _MarvalActivityState extends State<MarvalActivity> {
  bool _completed = false;
  @override
  Widget build(BuildContext context) {
    return  Row(
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
          child: Center(child: Icon(widget.icon, color: kWhite, size: 7.w,),),
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
              TextH2(widget.title, color: kWhite, size: 4.2,),
              Spacer(),
              Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.w),
                  border: Border.all(
                      width: 0.4.w,
                      color: kWhite
                  )
              ),
              child: CircleAvatar(
                backgroundColor: _completed ? kBlue : kBlack,
                radius: 1.8.w,
              ))
            ],
          ),
        ),
      ],
    );
  }
}

class MarvalActivityList extends StatelessWidget {
  const MarvalActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    return ListView.builder(
       itemCount: 7+1,
       scrollDirection: Axis.vertical,
       physics: BouncingScrollPhysics(),
       controller: ScrollController(
         keepScrollOffset: true
       ),
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
                   TextH2(" Completa tus tareas", size: 4, color: kWhite,),
                 ]),
           );
         }
         return Container(
             margin: EdgeInsets.only(bottom: 1.5.h),
             child: MarvalActivity(title: activities[index-1], icon: activities_icons[index-1],));
       });
  }
}

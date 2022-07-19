import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../constants/global_variables.dart';
import '../utils/decoration.dart';
import '../utils/marval_arq.dart';
import '../widgets/marval_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

///@TODO Get User data when is Already Logged.
///@TODO Main page Logic when is Logged but he doesnt complete de forms.

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if(isNull(dateNotifier)){ dateNotifier = ValueNotifier(DateTime.now()); }
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
      body:  Container( width: 100.w, height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Container(width: 100.w, height: 26.h,
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
            )),
            Container(width: 20.w, height: 10.h, color: kBlue,
            alignment: Alignment.topRight,
            child: Stack(
                children: [
                  Positioned(
                  right: 0,
                  child: Container(width: 20.w, height: 20.h,
                  decoration: BoxDecoration(
                    color: kWhite,
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
                        ),
                      ),
                    ),
              )),
            ]))
          ],
        )),
    );
  }
}

class DateList extends StatefulWidget {
  const DateList({required this.startDate, Key? key}) : super(key: key);
  final DateTime startDate;
  @override
  State<DateList> createState() => _DateListState();
}
class _DateListState extends State<DateList> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
     DateTime _lastMonday = widget.startDate.lastMonday();
    return  Container(width: 100.w, height: 10.h, child:
    ListView.builder(
        itemCount: 7,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
           DateTime _day =  _lastMonday.add(Duration(days: index));
          return Container(
              margin: EdgeInsets.only(right: 2.3.w),
              child: DateCell(date: _day));
        }));
  }
}


class DateCell extends StatefulWidget {
  const DateCell({required this.date, Key? key}) : super(key: key);
  final DateTime date;
  @override
  State<DateCell> createState() => _DateCellState();
}

class _DateCellState extends State<DateCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        dateNotifier!.value = widget.date;
        setState(() { });
      },
      child: Container(width: 11.w, height: 11.h,
      decoration: BoxDecoration(
        color:  dateNotifier!.value.day == widget.date.day ? kGreen : kBlack,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextH2("${widget.date.day}", color: kWhite, size: 4,),
          TextH2(widget.date.toStringWeekDay(),color: kWhite, size: 3,)

        ],),
     ));
  }
}

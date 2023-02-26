import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/screens/journal.dart';
import 'package:marvalfit/modules/home/widgets/calendar_widget.dart';
import 'package:marvalfit/modules/home/widgets/habit_widget.dart';
import 'package:marvalfit/modules/home/widgets/sleep_widget.dart';
import 'package:marvalfit/modules/home/widgets/weight_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

import '../../config/custom_icons.dart';
import '../../constants/colors.dart';
import '../../constants/shadows.dart';
import '../../constants/global_variables.dart';
import '../../constants/theme.dart';
import '../../utils/decoration.dart';
import '../../widgets/marval_drawer.dart';

ScrollController _scrollController = ScrollController();
HomeController _controller = HomeController();
int _snackCounter = 0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    _controller.init(context.ref);
    return Scaffold(
        drawer: const MarvalDrawer(name: "Agenda",),
        backgroundColor: kWhite,
        resizeToAvoidBottomInset: true,
        body:  SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: SizedBox( width: 100.w, height: 100.h,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ///Active User
                    Watcher((context, ref, child) {
                      watchActiveUser(context, ref);
                      return const SizedBox.shrink();
                    }),
                    Container(width: 100.w, height: 100.h,
                        color: kWhite,
                        child:  Watcher((context, ref, child) {
                          DateTime date = _controller.getDate(ref);
                          return Stack( children: [
                            /// Calendar Background
                            Positioned( top: 0,
                                child: Container(width: 100.w, height: 24.h,
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      color: kBlue,
                                      boxShadow: [kMarvalBoxShadow],
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.w)),
                                    ))),
                            /// Calendar Arrows
                            Positioned(
                              top: 0,
                              child: CalendarTitle(date: date),
                            ),
                            /// Date List
                            Positioned(
                                top: 8.h,
                                left: 6.w,
                                child: Container( width: 100.w,
                                  margin: EdgeInsets.only(top: 2.h),
                                  child: Center(child: DateList(date: date)),
                                )),
                            /// Little Box to make blue Right Margin
                            Positioned(right: 0, top: 23.h,
                                child: Container(width: 20.w, height: 10.h, color: kBlue
                                )),
                            Positioned(right: 0, top: 24.h,
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
                                            const MoonList()
                                          ]),
                                      const Spacer(),
                                      const MarvalWeight()
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
                            /// Activities Widget
                            Positioned( top: 66.5.h,
                                child: Journal(scrollController: _scrollController)
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
                          ]);
                        })
                    ),
                  ])),
        ));
  }
}

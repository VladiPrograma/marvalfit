import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../constants/theme.dart';
import '../utils/firebase/auth.dart';



class TestSleekScreen extends StatelessWidget {
  const TestSleekScreen({Key? key}) : super(key: key);
  static String routeName = "/testSleek";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: kWhite,
      body: SafeArea(child:
      Container(width: 100.w, height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Sleek()
          ]))
      ),
    );
  }
}
double max = 180;
double min = 0;
double init = 90;
double perc = init;

class Sleek extends StatefulWidget {
  const Sleek({Key? key}) : super(key: key);
  @override
  State<Sleek> createState() => _SleekState();
}

class _SleekState extends State<Sleek> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SleekCircularSlider(
            min: min,
            max: max,
            initialValue: init,
            onChangeEnd: (value) async{
              double _weight = double.parse(value.toStringAsPrecision(3));
              logInfo(_weight.toString());
              max+=perc-init;
              min+=perc-init;
              setState(() { });
              await Future.delayed(Duration(milliseconds: 100));
              init= (max+min)/2;
              setState(() {  });
            },
            appearance: CircularSliderAppearance(
              size: 38.w,
              startAngle: 0,
              customColors: CustomSliderColors(
                  progressBarColor: kBlue,
                  trackColor: kBlueSec,
                  hideShadow: true,
                  dotColor: kWhite
              ),
              angleRange: 180,
              customWidths: CustomSliderWidths(
                  trackWidth: 1.3.w,
                  progressBarWidth: 3.5.w,
                  handlerSize: 1.1.w
              ),
              animationEnabled: false,
            ),
            innerWidget: (percentage) => Center(
                child: TextH1(
                  "${percentage.toStringAsPrecision(3)}\nKg",
                  color: kBlack,
                  size: 5.5,
                  textAlign: TextAlign.center,
                )
            ),
            onChange: (double value) {
              logOut();
              perc = double.parse(value.toStringAsPrecision(3));
              logInfo(perc.toStringAsPrecision(3));
            }
        ),
        GestureDetector(
          onTap: () async{
            max+=perc-init;
            min+=perc-init;
            setState(() { });
            await Future.delayed(Duration(milliseconds: 100));
            init= (max+min)/2;
            setState(() {  });
          },
          child: Container(
            width: 50.w, height: 10.h,
            decoration: BoxDecoration(
            color: kBlack,
            borderRadius: BorderRadius.circular(9.w)
            ),
              child: Center(child: TextH2("Reload", size: 4, color: kWhite))),
        )
    ]);
  }
}



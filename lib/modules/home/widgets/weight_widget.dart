import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../constants/colors.dart';
import '../../../constants/theme.dart';

HomeController _controller = HomeController();
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
            child:  Watcher((context, ref, child) {
              Daily daily = _controller.getDaily(ref);
              final observer = _controller.hasChange(ref);

              return SleekCircularSlider (
                initialValue: _sleekInit,
                max: 2,
                min: -2,
                onChangeEnd: (value) {
                  // If we make sleekInit 0 as his initial value it doesn't change so Creator
                  // doesn't repaint his values so we neeed this += 0.001 to force the repaint
                  _sleekInit != 0 ? _sleekInit=0 : _sleekInit+=0.0001;
                  ///* Firebase Updates */
                  double currentWeight = daily.weight + value;
                  _controller.updateWeight(ref, daily, currentWeight);
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
                    TextH1( "${(daily.weight+percentage).toStringAsPrecision(3)}\nKg",
                      color: kWhite,
                      size: 5.5,
                      textAlign: TextAlign.center,
                    )),
              );
            },)));
  }
}
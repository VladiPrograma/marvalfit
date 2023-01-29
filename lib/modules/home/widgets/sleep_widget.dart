import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

/// Sleep Widget
HomeController _controller = HomeController();

class MoonList extends StatelessWidget {
  const MoonList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      Daily daily = _controller.getDaily(ref);
      final observer = _controller.hasChange(ref);
      return SizedBox(width: 55.w, height: 10.h,
        child:  ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                    margin: EdgeInsets.only(right: 2.3.w),
                    child:  Moon(num: index+1, daily: daily, ref: ref,));
              })
        );}
    );
  }
}
class Moon extends StatelessWidget {
  const Moon({required this.num, required this.daily, required this.ref,  Key? key}) : super(key: key);
  final int num;
  final Ref ref;
  final Daily daily;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
          onTap: () => _controller.updateSleep(ref, daily, num),
          child: Icon(
              CustomIcons.moon_inv,
              size: 9.w,
              color: daily.sleep < num ? kBlack : kBlue
          )
      );
  }
}
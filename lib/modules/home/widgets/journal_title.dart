import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/theme.dart';

final HomeController _controller = HomeController();
class JournalTitle extends StatelessWidget {
  const JournalTitle({this.topMargin, this.rightIcon, this.bottomMargin, this.onTap, required this.name, Key? key}) : super(key: key);
  final double? topMargin;
  final double? bottomMargin;
  final String name;
  final Function? onTap;
  final Widget? rightIcon;
  @override
  Widget build(BuildContext context) {
    return Container(width: 100.w,
        margin: EdgeInsets.only(top: topMargin?.h ?? 0, bottom: bottomMargin?.h ?? 0 ), // Fix the height
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( width: 25.w,
                  child: GestureDetector(
                    child: Icon(Icons.arrow_circle_left_outlined, size: 8.w, color: kGreen),
                    onTap: (){
                      if(isNotNull(onTap)) {onTap!();}
                      else{
                        _controller.initActivity(context.ref);
                      }
                    },
                  )),
              SizedBox(width: 50.w,
                  child: TextH2(name, size: 3.6, color: kWhite, textAlign: TextAlign.center,)),
              SizedBox(width: 25.w, child: rightIcon,)
            ]));
  }
}

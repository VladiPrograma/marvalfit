import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/theme.dart';
import '../logic/journal_creator.dart';

class JournalTitle extends StatelessWidget {
  const JournalTitle({this.topMargin, this.bottomMargin, this.onTap, required this.name, Key? key}) : super(key: key);
  final double? topMargin;
  final double? bottomMargin;
  final String name;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(width: 100.w,
      margin: EdgeInsets.only(top: topMargin?.h ?? 0, bottom: bottomMargin?.h ?? 0 ), // Fix the height
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox( width: 32.w,
                child: GestureDetector(
                  child: Icon(Icons.arrow_circle_left_outlined, size: 8.w, color: kGreen),
                  onTap: (){
                    if(isNotNull(onTap)) {onTap!();}
                    else{
                      watchJournal(context.ref) == JournalState.LIST ?
                      Navigator.pop(context) :
                      updateJournal(JournalState.LIST, context.ref);
                    }
                  },
                )),
            SizedBox(width: 43.w,
                child: TextH2(name, size: 4, color: kWhite)),
            SizedBox(width: 14.w,)
          ]));
  }
}

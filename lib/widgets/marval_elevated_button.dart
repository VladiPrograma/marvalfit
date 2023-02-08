import 'package:flutter/material.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';

class MarvalElevatedButton extends StatefulWidget {
  const MarvalElevatedButton(String this.text,{required this.onPressed, this.backgroundColor, this.textColor, this.textSize,  Key? key}) : super(key: key);

  final MaterialStateProperty<Color>? backgroundColor;
  final Function() onPressed;
  final Color? textColor;
  final String? text;
  final double? textSize;
  @override
  State<MarvalElevatedButton> createState() => _MarvalElevatedButtonState();
}

class _MarvalElevatedButtonState extends State<MarvalElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
            backgroundColor: widget.backgroundColor ?? MaterialStateColor.resolveWith((states){
              return states.contains(MaterialState.pressed) ? kGreen : kBlack;
            }),
            elevation: MaterialStateProperty.all(2.w),
            shape: MaterialStateProperty.all( RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)))
        ),

        child: Container(
            padding: EdgeInsets.all(1.71.w),
            child:  TextH2(widget.text ?? "", color: widget.textColor ?? kWhite, size: widget.textSize,))
    );
  }
}

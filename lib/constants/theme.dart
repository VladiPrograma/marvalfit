import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constants/string.dart';
import '../../constants/colors.dart';



class TextH1 extends StatelessWidget {
  final String text;
  final double size;
  const TextH1({Key? key,required this.text, required this.size}) : super(key: key);
  Widget build(BuildContext context) {
    return Text( text, style:
    TextStyle(
      fontFamily: h1,
      fontSize: size.w,
      color: kBlack,
    ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constants/string.dart';
import '../../constants/colors.dart';


/// H1 Sizes: 9 //
/// H2 Sizes: 4 // 3 [ error msg ] //
/// P1 Sizes: 4 //
/// P2 Sizes

class TextH1 extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final TextAlign? textAlign;
  const TextH1(String this.text,{Key? key, this.size, this.color, this.textAlign}) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
      fontFamily: h1,
      fontSize: size?.w ?? 9.w,
      color: color ?? kBlack,
      ),
    );
  }
}
class TextH2 extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  const TextH2(String this.text,{Key? key, this.size, this.color}) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      style: TextStyle(
        fontFamily: h2,
        fontSize: size?.w ?? 5.w,
        color: color ?? kBlack,
      ),
    );
  }
}
class TextP1 extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  const TextP1(String this.text,{Key? key, this.size, this.color}) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: p1,
        fontSize: size?.w ?? 4.w,
        color: color ?? kBlack,
      ),
    );
  }
}
class TextP2 extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  const TextP2(String this.text,{Key? key, this.size, this.color}) : super(key: key);

  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontFamily: p2,
        fontSize: size?.w,
        color: color ?? kBlack,
      ),
    );
  }
}
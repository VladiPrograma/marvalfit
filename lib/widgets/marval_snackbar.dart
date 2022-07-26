import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';

 enum SNACKTYPE { info, alert, success}

void MarvalSnackBar(BuildContext context, SNACKTYPE type, {String? title, String? subtitle}){
   late Color _backgroundColor;
   late Color _iconColor;
   late List<Color> _barColor;
   late IconData _icon;

   if(type == SNACKTYPE.info){
    _backgroundColor = kBlueThi;
    _iconColor = kBlue;
    _barColor = [kBlue, kBlueSec];
    _icon = CustomIcons.info;
   }else if(type == SNACKTYPE.alert){
     _backgroundColor = kRedThi;
     _iconColor = kRed;
     _barColor = [kRed, kRedSec];
     _icon = CustomIcons.alert;
   }else{
     _backgroundColor = kGreenThi;
     _iconColor = kGreen;
     _barColor = [kGreen, kGreenSec];
     _icon = Icons.tag_faces_rounded ;
   }
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: _backgroundColor,
          content: Container(width: 100.w, height: 10.h,
              decoration: BoxDecoration(
                color: _backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: kBlack.withOpacity(0.6),
                    spreadRadius: 1.w,
                    blurRadius: 6.w,
                    offset: Offset(0, 1.w), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 1.h, bottom: 0),
              child: Column(
                children: [
                  Container(width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon( _icon, color: _iconColor, size: 13.w,),
                          Container(height: 6.h, width: 0.4.w,
                            color: kGrey,
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextH2(title ?? "", size: 4,),
                              SizedBox(
                                  width: 69.w,
                                  child: Text(
                                    subtitle ?? "",
                                    style: TextStyle( fontSize: 2.6.w, color: kBlack, fontFamily: p1),
                                    maxLines: 2,
                                  )
                              ),

                            ],
                          )
                        ],
                      )),
                  const Spacer(),
                  SnackLineAnimation(colors: _barColor),
                ],
              )
          ))
  );
}

class SnackLineAnimation extends StatefulWidget {
  const SnackLineAnimation({required this.colors, Key? key}) : super(key: key);
  final List<Color> colors;
  @override
  State<SnackLineAnimation> createState() => _SnackLineAnimationState();
}
class _SnackLineAnimationState extends State<SnackLineAnimation> with SingleTickerProviderStateMixin{
  double _dx = 0;
  late AnimationController _controller;
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _controller.addListener(_update);
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update(){
    setState(() {
      _dx = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
          bottom: 0,
          child: Container(
              width: 100.w, height: 0.5.h,
              color: widget.colors[1],
              margin: EdgeInsets.only(right: _dx.w)
          )
      ),
      AnimatedContainer(
        width: 100.w, height: 0.5.h,
        color: widget.colors[0],
        duration: const Duration(milliseconds: 4000),
        curve: Curves.linear,
        margin: EdgeInsets.only(right: _dx.w),
      ),
    ],);

  }
}
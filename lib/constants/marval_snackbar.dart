import 'package:flutter/material.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';


void MarvalSnackBar(BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          padding: EdgeInsets.zero,
          backgroundColor: kBlueThi,
          content: Container(width: 100.w, height: 10.h,
              padding: EdgeInsets.only(top: 1.h, bottom: 0),
              child: Column(
                children: [
                  Container(width: 100.w,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info, color: kBlue, size: 13.w,),
                          Container(height: 6.h, width: 0.4.w,
                            color: kGrey,
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextH2("Revisa tus datos", size: 4,),
                              SizedBox(
                                  width: 69.w,
                                  child: Text(
                                    "Se debe a un problema en la configuracion de la la la la la tu sabras como lo gestionas",
                                    style: TextStyle( fontSize: 2.3.w, color: kBlack, fontFamily: p1),
                                    maxLines: 2,
                                  )
                              ),

                            ],
                          )
                        ],
                      )),
                  const Spacer(),
                  SnackLineAnimation(),
                ],
              )
          ))
  );
}

class SnackLineAnimation extends StatefulWidget {
  const SnackLineAnimation({Key? key}) : super(key: key);

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
              color: kBlueSec,
              margin: EdgeInsets.only(right: _dx.w)
          )
      ),
      AnimatedContainer(
        width: 100.w, height: 0.5.h,
        color: kBlue,
        duration: const Duration(milliseconds: 4000),
        curve: Curves.linear,
        margin: EdgeInsets.only(right: _dx.w),
      ),
    ],);

  }
}
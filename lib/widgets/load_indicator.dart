import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';

class LoadIndicator extends StatelessWidget {
  const LoadIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SpinKitCircle(
      size: 9.w,
      color: kGrey,
    );
  }
}
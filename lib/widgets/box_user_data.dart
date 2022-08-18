import 'package:flutter/material.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../constants/colors.dart';
import '../constants/components.dart';
import '../constants/theme.dart';
import '../utils/marval_arq.dart';
import '../utils/objects/user.dart';

class BoxUserData extends StatelessWidget {
  const BoxUserData({required this.user, Key? key}) : super(key: key);
  final MarvalUser user;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Container(
              decoration: BoxDecoration(
                boxShadow: [kMarvalHardShadow],
                borderRadius: BorderRadius.all(Radius.circular(100.w)),
              ),
              child: CircleAvatar(
                  backgroundColor: kBlack,
                  radius: 6.h,
                  backgroundImage:  isNullOrEmpty(user.profileImage) ?
                  null
                      :
                  Image.network(user.profileImage!, fit: BoxFit.fitHeight).image
              )),
          SizedBox(width: 2.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h,),
                TextH2('${user.name.clearSimbols()} ${user.lastName}', size: 4),
                TextH2(user.work, size: 3, color: kGrey,),
              ])
        ]);
  }
}
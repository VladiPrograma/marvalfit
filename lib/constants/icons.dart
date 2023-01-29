import 'package:flutter/material.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';

import '../config/custom_icons.dart';

const Map<ActivityType, IconData?> mapIcons = {
  ActivityType.GYM   :  CustomIcons.gym,
 ActivityType.REST : CustomIcons.bed,
 ActivityType.GALLERY : CustomIcons.camera_retro,
 ActivityType.MEASURES : CustomIcons.tape,
 ActivityType.CARDIO : CustomIcons.health,

};
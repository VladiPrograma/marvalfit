import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/constants/string.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/utils/extensions.dart';

import '../../config/log_msg.dart';
import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/planing.dart';
import '../../utils/objects/user_daily.dart';


Creator<DateTime> weekCreator = Creator.value(DateTime.now().lastMonday());
Creator<ActivityType> activityCreator = Creator.value(ActivityType.EMPTY);


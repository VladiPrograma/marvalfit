import 'package:flutter/material.dart';

import '../core/get_user_data/get_user_data_screen.dart';
import '../core/get_user_data/get_user_data_metrics.dart';
import '../test/snackbar_and_dialogs.dart';
import '../core/login/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  LoginScreen(),
  TestComponentScreen.routeName : (context) =>  TestComponentScreen(),
  GetUserDataScreen.routeName : (context) =>  GetUserDataScreen(),
  GetUserMetricsScreen.routeName : (context) =>  GetUserMetricsScreen(),
};
import 'package:flutter/material.dart';
import 'package:marvalfit/core/get_user_data/form_screen.dart';
import 'package:marvalfit/modules/home_screen.dart';

import '../core/get_user_data/get_user_data_screen.dart';
import '../core/get_user_data/get_user_data_metrics.dart';
import '../test/snackbar_and_dialogs.dart';
import '../core/login/login_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  LoginScreen(),
  TestComponentScreen.routeName : (context) =>  TestComponentScreen(),
  GetUserDataScreen.routeName : (context) =>  GetUserDataScreen(),
  GetUserMetricsScreen.routeName : (context) =>  GetUserMetricsScreen(),
  FormScreen.routeName : (context) => FormScreen(),
  HomeScreen.routeName : (context) => HomeScreen(),
};
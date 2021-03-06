import 'package:flutter/material.dart';
///* Test Pages */
import 'package:marvalfit/core/get_user_data/form_screen.dart';
import 'package:marvalfit/test/sleek_change.dart';
import '../test/snackbar_and_dialogs.dart';

///* App Pages */
import '../core/login/login_screen.dart';
import '../core/get_user_data/get_user_data_screen.dart';
import '../core/get_user_data/get_user_details_screen.dart';
import 'package:marvalfit/modules/home_screen.dart';


final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  LoginScreen(),
  TestComponentScreen.routeName : (context) =>  TestComponentScreen(),
  GetUserDataScreen.routeName : (context) =>  GetUserDataScreen(),
  GetUserDetails.routeName : (context) =>  GetUserDetails(),
  FormScreen.routeName : (context) => FormScreen(),
  HomeScreen.routeName : (context) => HomeScreen(),
  TestSleekScreen.routeName : (context) => TestSleekScreen(),
};
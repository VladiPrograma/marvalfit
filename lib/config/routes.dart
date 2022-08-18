import 'package:flutter/material.dart';

import '../modules/profile/profile_screen.dart';
///* Test Pages */
import '../test/sleek_change.dart';
import '../test/snackbar_and_dialogs.dart';

///* App Pages */
import '../core/login/login_screen.dart';
import '../core/get_user_data/form_screen.dart';
import '../core/get_user_data/get_user_data_screen.dart';
import '../core/get_user_data/get_user_details_screen.dart';

import '../modules/home/home_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/ajustes/settings_screen.dart';
import '../modules/ajustes/ajuste/change_email_screen.dart';
import '../modules/ajustes/ajuste/change_password_screen.dart';



final Map<String, WidgetBuilder> routes = {
  ///* Core Screens */
  LoginScreen.routeName : (context) =>  LoginScreen(),
  GetUserDataScreen.routeName : (context) =>  GetUserDataScreen(),
  GetUserDetails.routeName : (context) =>  GetUserDetails(),
  FormScreen.routeName : (context) => FormScreen(),
  ///* Module Screens */
  HomeScreen.routeName : (context) => HomeScreen(),
  ChatScreen.routeName : (context) => ChatScreen(),
  ProfileScreen.routeName : (context) => ProfileScreen(),
  ///* Setting Screens */
  SettingScreen.routeName : (context) => SettingScreen(),
  ResetEmailScreen.routeName : (context) => ResetEmailScreen(),
  ResetPasswordScreen.routeName : (context) => ResetPasswordScreen(),
  ///* Test Screens */
  TestSleekScreen.routeName : (context) => TestSleekScreen(),
  TestComponentScreen.routeName : (context) =>  TestComponentScreen(),
};
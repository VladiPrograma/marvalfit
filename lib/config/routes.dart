import 'package:flutter/material.dart';
import 'package:marvalfit/modules/exercise/exercise_home_screen.dart';
import 'package:marvalfit/modules/exercise/exercise_screen.dart';
import 'package:marvalfit/modules/profile/journal/see_form_screen.dart';

///* Test Pages */
import '../test/sleek_change.dart';
import '../test/snackbar_and_dialogs.dart';

///* App Pages */
import '../core/login/login_screen.dart';
import '../core/get_user_data/form_screen.dart';
import '../core/get_user_data/get_user_data_screen.dart';
import '../core/get_user_data/get_user_details_screen.dart';

import '../modules/settingsv2/labels/change_email_screen.dart';
import '../modules/settingsv2/labels/change_password_screen.dart';
import '../modules/settingsv2/settings_screen.dart';

import '../modules/home/home_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/profile/profile_screen.dart';


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
  SeeFormScreen.routeName : (context) => SeeFormScreen(),
  ///* Setting Screens */
  SettingScreen.routeName : (context) => const SettingScreen(),
  ResetEmailScreen.routeName : (context) =>const ResetEmailScreen(),
  ResetPasswordScreen.routeName : (context) => const ResetPasswordScreen(),
  ///* Test Screens */
  TestSleekScreen.routeName : (context) => const TestSleekScreen(),
  TestComponentScreen.routeName : (context) => const  TestComponentScreen(),
  // EXERCISES
  ExerciseHomeScreen.routeName : (context) =>  const ExerciseHomeScreen(),
  ExerciseScreen.routeName : (context) => const ExerciseScreen(),
};
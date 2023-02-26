import 'package:flutter/material.dart';
import 'package:marvalfit/modules/chat/chat_user_screen.dart';
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

import '../modules/settings/labels/change_email_screen.dart';
import '../modules/settings/labels/change_password_screen.dart';
import '../modules/settings/settings_screen.dart';

import '../modules/home/home_screen.dart';
import '../modules/profile/profile_screen.dart';


final Map<String, WidgetBuilder> routes = {
  ///* Core Screens */
  LoginScreen.routeName : (context) =>  const LoginScreen(),
  GetUserDataScreen.routeName : (context) =>  const GetUserDataScreen(),
  GetUserDetails.routeName : (context) =>  const GetUserDetails(),
  FormScreen.routeName : (context) => const FormScreen(),
  ///* Module Screens */
  HomeScreen.routeName : (context) => const HomeScreen(),
  ChatScreen.routeName : (context) => const ChatScreen(),
  ProfileScreen.routeName : (context) => const ProfileScreen(),
  SeeFormScreen.routeName : (context) => const SeeFormScreen(),
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
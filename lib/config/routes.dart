import 'package:flutter/material.dart';

import '../core/login/login_screen.dart';
import '../test_marval_components.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName : (context) =>  LoginScreen(),
  TestComponentScreen.routeName : (context) =>  TestComponentScreen(),
};
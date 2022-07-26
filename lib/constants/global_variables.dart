import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/objects/user.dart';

/// - - - FIREBASE AUTH - - -  */
 User? authUser;
 late MarvalUser user;

/// HOME VARIABLES */
late ValueNotifier<DateTime> dateNotifier;
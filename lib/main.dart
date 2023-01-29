import 'package:cached_network_image/cached_network_image.dart';
import 'package:creator/creator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:marvalfit/core/get_user_data/get_user_data_screen.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/firebase/authentication/logic/auth_user_logic.dart';

import 'package:marvalfit/modules/home/home_screen.dart';
import 'package:marvalfit/utils/firebase/auth.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/utils/objects/form.dart';
import 'package:marvalfit/utils/objects/user.dart';

import 'config/firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'config/routes.dart';

///* @TODO Change the Drawer Navigator Routes
///* @TODO Drawer have to say "Bienvenido//Bienvenida"
///* @TODO Complete full form data to Firebase"
///* @TODO Open images when user press on it.

///* @TODO Add Splash Load Screen to IOS
///  https://pub.dev/packages/flutter_native_splash/install

///@TODO when restart the BD change 'users_curr' name.
///@TODO using settings i lost Home page when i press back...


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(CreatorGraph(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userLogic.get(context.ref);
    return Sizer(
        builder: (context, orientation, deviceType) {
          AuthUserLogic auth = AuthUserLogic();
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalMaterialLocalizations.delegate
            ],
            scaffoldMessengerKey: snackbarKey,
            supportedLocales: const [
               Locale('en'),
               Locale('es_ES')
            ],
            debugShowCheckedModeBanner: false,
            title: 'Comienza el reto',
            routes: routes,
            //TODO  go to GetUserDataScreen if he doesn't complete his data yet.
            initialRoute: auth.get() == null ? LoginScreen.routeName : HomeScreen.routeName
          );
        }
    );
  }
}




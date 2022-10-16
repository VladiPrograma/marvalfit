import 'package:cached_network_image/cached_network_image.dart';
import 'package:creator/creator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:marvalfit/core/get_user_data/get_user_data_screen.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/constants/global_variables.dart';

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

bool _isDataCompleted = false;

MarvalUser? _auxUser;
void main() async{
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   User? auxAuthUser = getCurrUser();
   _isDataCompleted = await MarvalForm.existsInDB(auxAuthUser?.uid);

  if(isNotNull(auxAuthUser)){
    authUser = auxAuthUser!;
    _auxUser = await MarvalUser.getFromDB(auxAuthUser.uid);
    if(_auxUser!.active) { authUser = auxAuthUser; user = _auxUser!; }
    else                 { logOut(); auxAuthUser = null; }

  }

  runApp(CreatorGraph( child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
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
            initialRoute: isNull(_auxUser)||!_auxUser!.active ? LoginScreen.routeName :
                _isDataCompleted ?
                HomeScreen.routeName
                    :
                GetUserDataScreen.routeName
          );
        }
    );
  }
}




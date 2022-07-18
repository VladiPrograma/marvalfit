import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marvalfit/core/get_user_data/form_screen.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/modules/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'config/firebase_options.dart';
import 'config/routes.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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
            supportedLocales: const [
               Locale('en'),
               Locale('es_ES')
            ],
            debugShowCheckedModeBanner: false,
            title: 'Comienza el reto',
            routes: routes,
            initialRoute: HomeScreen.routeName,
          );
        }
    );
  }
}





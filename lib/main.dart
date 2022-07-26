import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/core/get_user_data/get_user_data_screen.dart';
import 'package:marvalfit/core/login/login_screen.dart';
import 'package:marvalfit/modules/home_screen.dart';
import 'package:marvalfit/utils/firebase/auth.dart';
import 'package:marvalfit/utils/marval_arq.dart';
import 'package:marvalfit/utils/objects/user.dart';
import 'package:sizer/sizer.dart';
import 'config/firebase_options.dart';
import 'config/routes.dart';


bool _flag = false;
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  authUser = getCurrUser();
  _flag = await MarvalUser.existsInDB(authUser?.uid);
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
            initialRoute: isNull(authUser) ? LoginScreen.routeName :
                _flag ? HomeScreen.routeName :
                GetUserDataScreen.routeName
          );
        }
    );
  }
}




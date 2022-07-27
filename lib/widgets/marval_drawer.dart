import 'package:flutter/material.dart';
import 'package:marvalfit/core/get_user_data/get_user_data_metrics.dart';
import 'package:marvalfit/modules/home_screen.dart';
import 'package:marvalfit/test/sleek_change.dart';
import 'package:marvalfit/test/snackbar_and_dialogs.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';
import '../constants/global_variables.dart';
import '../constants/theme.dart';
import '../core/login/login_screen.dart';
import '../utils/marval_arq.dart';

class MarvalDrawer extends StatelessWidget {
  const MarvalDrawer({required this.name, Key? key}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kWhite,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        children:  <Widget>[
          SizedBox(height: 39.h,
              child: DrawerHeader(
                decoration: BoxDecoration( color: kWhite, border: Border.all(color: kWhite) ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: isNotNull(authUser!.photoURL) ? Image.network(authUser!.photoURL!).image : null,
                      backgroundColor: kBlack,
                      radius: 19.w,
                      child: isNull(authUser!.photoURL) ? Icon(CustomIcons.person, color: kWhite, size: 13.w,): null,
                    ),
                    const TextH2('Bienvenido', color: kGrey, size: 6,),
                    TextH1(authUser!.displayName!, color: kBlack, size: 100/(authUser!.displayName!.length+7),),
                  ],
                ),
              )),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, HomeScreen.routeName);},
            child: ListTile(
              leading: Icon(Icons.home_rounded,color: name=="Home" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Home', size: 4, color: name=="Home" ? kGreen : kBlack),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, TestSleekScreen.routeName);},
            child: ListTile(
              leading: Icon(Icons.message_outlined,color: name=="Chat" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Chat', size: 4, color: name=="Chat" ? kGreen : kBlack),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, GetUserMetricsScreen.routeName);},
            child: ListTile(
              leading: Icon(Icons.run_circle_outlined,color: name=="Ejercicios" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Ejercicios', size: 4, color: name=="Ejercicios" ? kGreen : kBlack),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.routeName);},
            child: ListTile(
              leading: Icon(CustomIcons.person ,color: name=="Perfil" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Perfil', size: 4, color: name=="Perfil" ? kGreen : kBlack),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, TestComponentScreen.routeName);},
            child: ListTile(
              leading: Icon(Icons.settings_rounded,color: name=="Ajustes" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Ajustes', size: 4, color: name=="Ajustes" ? kGreen : kBlack),
            ),
          ),
          SizedBox(height: 7.h),
          Container( height: 15.h,
            child: Image.asset('assets/images/marval_logo.png'),)
        ],
      ),
    );
  }
}
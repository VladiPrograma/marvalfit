import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/modules/chat/chat_logic.dart';
import 'package:marvalfit/test/snackbar_and_dialogs.dart';
import 'package:marvalfit/utils/firebase/auth.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../constants/colors.dart';
import '../constants/global_variables.dart';
import '../constants/theme.dart';
import '../core/get_user_data/get_user_details_screen.dart';
import '../core/login/login_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/home/home_screen.dart';
import '../utils/marval_arq.dart';

class MarvalDrawer extends StatelessWidget {
  const MarvalDrawer({required this.name, Key? key}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    final String userName = authUser!.displayName!;
    return Drawer(
      backgroundColor: kWhite,
      child: SizedBox( height: 100.h,
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
                      radius: 9.h,
                      child: isNull(authUser!.photoURL) ? Icon(CustomIcons.person, color: kWhite, size: 13.w,): null,
                    ),
                    const TextH2('Bienvenido', color: kGrey, size: 6,),
                    TextH1(userName.length<13 ? userName : userName.substring(0,13), color: kBlack, size: 8, textOverFlow: TextOverflow.clip ,),
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
              Navigator.pushNamed(context, ChatScreen.routeName);},
            child: ListTile(
              leading: Icon(Icons.chat_rounded, color: name=="Chat" ? kGreen : kBlack, size: 6.w,),
              title: Watcher((context, ref, _) {
                int notifications = 0;
                final data = getLoadMessages(ref);
                notifications = data?.where((element) => element.user!=authUser!.uid && !element.read).length ?? 0;
                return Row( children: [
                  TextH2('Chat', size: 4, color: name == "Chat" ? kGreen : kBlack),
                  SizedBox(width: 3.w,),
                  notifications == 0 ?
                  const SizedBox()
                      :
                  CircleAvatar( radius: 2.w, backgroundColor: kRed, child: TextH1('$notifications', color: kWhite, size: 2,),)
                ]);
              }),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, GetUserDetails.routeName);},
            child: ListTile(
              leading: Icon(Icons.run_circle_outlined,color: name=="Ejercicios" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Ejercicios', size: 4, color: name=="Ejercicios" ? kGreen : kBlack),
            ),
          ),
          GestureDetector(
            onTap: (){
              logOut();
              Navigator.popAndPushNamed(context, LoginScreen.routeName);},
            child: ListTile(
              leading: Icon(CustomIcons.person ,color: name == "Perfil" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Perfil', size: 4, color:  name == "Perfil" ? kGreen : kBlack),
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
          SizedBox(height: 10.h,),
          SizedBox( height: 15.h, child: Image.asset('assets/images/marval_logo.png'),)
        ],
      ),
    ));
  }
}
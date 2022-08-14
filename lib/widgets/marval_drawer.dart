import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/test/sleek_change.dart';
import 'package:sizer/sizer.dart';

import '../config/custom_icons.dart';
import '../config/log_msg.dart';
import '../constants/colors.dart';
import '../constants/global_variables.dart';
import '../constants/theme.dart';
import '../modules/ajustes/settings_screen.dart';
import '../modules/chat/chat_screen.dart';
import '../modules/home/home_screen.dart';
import '../utils/marval_arq.dart';


final _notificationsCreator = Emitter.stream((ref) async {
  logSuccess('NotificationCreator updated');
  return FirebaseFirestore.instance.collection('users/${authUser.uid}/chat')
      .where('read', isEqualTo: false)
      .where('user', isNotEqualTo: authUser.uid)
      .limit(5)
      .snapshots();
});
int _watchNotifications(Ref ref){
  final query = ref.watch(_notificationsCreator.asyncData).data;
  if(isNull(query)||query!.size==0){ return 0; }
  //Pass data from querySnapshot to Messages
  return query.size;
}

class MarvalDrawer extends StatelessWidget {
  const MarvalDrawer({required this.name, Key? key}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    final String userName = authUser.displayName!;
    return Drawer(
      backgroundColor: kWhite,
      child: SizedBox( height: 100.h,
        child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        children:  <Widget>[
          ///* HEADER
          SizedBox(height: 39.h,
              child: DrawerHeader(
                decoration: BoxDecoration( color: kWhite, border: Border.all(color: kWhite) ),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: isNotNull(authUser.photoURL) ? Image.network(authUser.photoURL!).image : null,
                      backgroundColor: kBlack,
                      radius: 9.h,
                      child: isNull(authUser.photoURL) ? Icon(CustomIcons.person, color: kWhite, size: 13.w,): null,
                    ),
                    const TextH2('Bienvenido', color: kGrey, size: 6,),
                    TextH1(userName.length<13 ? userName : userName.substring(0,13), color: kBlack, size: 8, textOverFlow: TextOverflow.clip ,),
                  ],
                ),
              )),
          /// Home
          GestureDetector(
            onTap: () =>  Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false),
            child: ListTile(
              leading: Icon(Icons.home_rounded,color: name=="Home" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Home', size: 4, color: name=="Home" ? kGreen : kBlack),
            ),
          ),
          /// Chat
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
              Navigator.pushNamed(context, ChatScreen.routeName);
            },
            child: ListTile(
              leading: Icon(CustomIcons.chat_empty, color: name=="Chat" ? kGreen : kBlack, size: 6.w,),
              title: Watcher((context, ref, _) {
                int notification = _watchNotifications(ref);
                return Row( children: [
                  TextH2('Chat', size: 4, color: name == "Chat" ? kGreen : kBlack),
                  SizedBox(width: 3.w,),
                  notification == 0 ?
                  const SizedBox()
                      :
                  CircleAvatar( radius: 2.w, backgroundColor: kRed, child: TextH1('$notification', color: kWhite, size: 2,),)
                ]);
              }),
            ),
          ),
          /// Ejercicios
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
              Navigator.pushNamed(context, SettingScreen.routeName);
            },
            child: ListTile(
              leading: Icon(CustomIcons.gym, color: name=="Ejercicios" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Ejercicios', size: 4, color: name=="Ejercicios" ? kGreen : kBlack),
            ),
          ),
          /// Perfil
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
              Navigator.pushNamed(context, TestSleekScreen.routeName);
            },
            child: ListTile(
              leading: Icon(CustomIcons.person ,color: name == "Perfil" ? kGreen : kBlack, size: 6.w,),
              title: TextH2('Perfil', size: 4, color:  name == "Perfil" ? kGreen : kBlack),
            ),
          ),
          /// Ajustes
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName));
              Navigator.pushNamed(context, SettingScreen.routeName);
            },
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
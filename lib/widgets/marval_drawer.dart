import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/firebase/messages/model/message.dart';
import 'package:marvalfit/firebase/users/model/user.dart';
import 'package:marvalfit/modules/chat/chat_user_screen.dart';
import 'package:marvalfit/modules/exercise/exercise_home_screen.dart';
import 'package:marvalfit/modules/settings/settings_screen.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/widgets/cached_avatar_image.dart';
import 'package:sizer/sizer.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/modules/home/home_screen.dart';
import 'package:marvalfit/modules/profile/profile_screen.dart';


void removeScreens(BuildContext context, String routeName){
  while(Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  Navigator.pushNamed(context, routeName);
}

class MarvalDrawer extends StatelessWidget {
  const MarvalDrawer({required this.name, Key? key}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {

    return Drawer(
        backgroundColor: kWhite,
        child: SizedBox( height: 100.h,
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            children:  <Widget>[
              /// Header
              Watcher((context, ref, child) {
                User? user = userLogic.get(ref);
                return SizedBox(height: 38.h,
                    child: DrawerHeader(
                      decoration: BoxDecoration( color: kWhite, border: Border.all(color: kWhite) ),
                      child: Column(
                        children: [
                          CachedAvatarImage(url: user?.profileImage ?? '', size: 9),
                          const TextH2('Bienvenido', color: kGrey, size: 6,),
                          TextH1(user?.name.maxLength(13) ?? "" , color: kBlack, size: 7.5, textOverFlow: TextOverflow.clip ,),
                        ],
                      ),
                    ));
              }),
              /// Profile
              GestureDetector(
                onTap: () => removeScreens(context, ProfileScreen.routeName),
                child: ListTile(
                  leading: Icon(CustomIcons.person,color: name=="Perfil" ? kGreen : kBlack, size: 6.w,),
                  title: TextH2('Perfil', size: 4, color: name=="Perfil" ? kGreen : kBlack),
                ),
              ),
              /// Home
              GestureDetector(
                onTap: () => removeScreens(context,HomeScreen.routeName),
                child: ListTile(
                  leading: Icon(Icons.menu_book, color: name=="Agenda" ? kGreen : kBlack, size: 6.w,),
                  title: TextH2('Agenda', size: 4, color: name=="Agenda" ? kGreen : kBlack),
                ),
              ),
              /// Chat
              Watcher((context, ref, child) {
                List<Message> list =  messagesLogic.getUnread(ref);
                int unread = list.length;
                if(unread > 999) unread = 999;
                return GestureDetector(
                  onTap: () {
                    removeScreens(context,ChatScreen.routeName);
                    list.forEach((message) {messagesLogic.read(message);});
                  },
                  child: ListTile(
                    leading: Icon(Icons.chat, color: name=="Chat" ? kGreen : kBlack, size: 5.w,), //CustomIcons.chat
                    title:  Row( children: [
                        TextH2('Chat', size: 4, color: name == "Chat" ? kGreen : kBlack),
                        SizedBox(width: 3.w,),
                        unread == 0 ?
                        const SizedBox()
                            :
                        CircleAvatar( radius: 2.3.w, backgroundColor: kRed, child: TextH1('$unread', color: kWhite, size: 2,),)
                      ])
                  ),
                );
              }),
              GestureDetector(
                onTap: () => removeScreens(context,  ExerciseHomeScreen.routeName),
                child: ListTile(
                  leading: Icon(CustomIcons.moon,color: name=="Ejercicios" ? kGreen : kBlack, size: 6.w,),
                  title: TextH2('Ejercicios', size: 4, color: name=="Ejercicios" ? kGreen : kBlack),
                ),
              ),
              /// Ajustes
              GestureDetector(
                onTap: () => removeScreens(context, SettingScreen.routeName),
                child: ListTile(
                  leading: Icon(Icons.settings_rounded,color: name=="Ajustes" ? kGreen : kBlack, size: 7.w,),
                  title: TextH2('Ajustes', size: 4, color: name=="Ajustes" ? kGreen : kBlack),
                ),
              ),
              SizedBox( height: 12.h,
                child: Image.asset('assets/images/marval_logo.png'),)
            ],
          ),
        ));
  }
}

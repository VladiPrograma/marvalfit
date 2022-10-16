import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../home/home_screen.dart';

import '../../utils/decoration.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user.dart';
import '../../utils/extensions.dart';

import '../../widgets/marval_drawer.dart';

import '../../config/custom_icons.dart';
import '../../constants/global_variables.dart';
import '../../constants/colors.dart';
import '../../constants/shadows.dart';
import '../../constants/theme.dart';

import '../../modules/profile/gallery.dart';
import '../../modules/profile/see_form_screen.dart';

import 'diary.dart';
import 'habits.dart';
import 'logic.dart';
import 'measures.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static String routeName = "/profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MarvalDrawer(page: "Perfil",),
        backgroundColor: kWhite,
        body:  SizedBox( width: 100.w, height: 100.h,
          child: Stack(
            children: [
             /// Grass Image
             Positioned( top: 0,
             child: SizedBox(width: 100.w, height: 12.h,
             child: Image.asset('assets/images/grass.png',
             fit: BoxFit.cover
             ))),
             ///White Container
             Positioned( top: 8.h,
              child: Container(width: 100.w, height: 10.h,
               decoration: BoxDecoration(
               color: kWhite,
               borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w)
               ))
             )),
             /// User Box Data
             Positioned(  top: 1.h,
             child: SafeArea(
              child: SizedBox(width: 100.w, child: ProfileUserData(user: user))
             )),
              /// Activities Background
              Positioned( top: 28.h,
                  child: InnerShadow(
                    color: Colors.black,
                    offset: Offset(0, 0.7.h),
                    blur: 1.5.w,
                    child: Container( width: 100.w, height: 72.h,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: kBlack,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12.w),
                              topLeft: Radius.circular(12.w)
                          ),
                        )),
                  )),
              /// Ativities Widget
              Positioned( top: 28.h, child: Journal() ),
              ///Shadow ¿? @Wtf is this?
              // Positioned( top: 2.h, left: 6.w,
              //     child: Container( width: 88.w, height: 1.3.h,
              //         padding: EdgeInsets.symmetric(horizontal: 4.w),
              //         decoration: BoxDecoration(
              //             color: Colors.transparent,
              //             borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(12.w),
              //                 topLeft:  Radius.circular(12.w)),
              //             boxShadow: [  BoxShadow(
              //               color: Colors.black.withOpacity(0.8),
              //               offset: Offset(0, 1.5.h),
              //               blurRadius: 4.w,
              //             )]
              //         ))
              // ),
       ])
      ),
    );
  }
}

class ProfileUserData extends StatelessWidget {
  const ProfileUserData({required this.user, Key? key}) : super(key: key);
  final MarvalUser user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            children: [
              /// Profile image
              SizedBox(width: 8.w),
              Container(
                  decoration: BoxDecoration(
                    boxShadow: [kMarvalHardShadow],
                    borderRadius: BorderRadius.all(Radius.circular(100.w)),
                  ),
                  child: CircleAvatar(
                      backgroundColor: kBlack,
                      radius: 6.h,
                      backgroundImage:  isNullOrEmpty(user.profileImage) ?
                      null
                          :
                      Image.network(user.profileImage!, fit: BoxFit.fitHeight).image
                  )),
              SizedBox(width: 2.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h,),
                    TextH2('${user.name.clearSimbols()} ${user.lastName}', size: 4),
                    TextH2(user.work, size: 3, color: kGrey,),
                    TextH2((user.hobbie + ' y ' + user.favoriteFood).maxLength(25), size: 3, color: kGrey,),
                  ]),
              const Spacer(),
              Padding(padding: EdgeInsets.only(top: 4.5.h),
                  child: GestureDetector(
                    onTap: (){ Navigator.pushNamed(context, SeeFormScreen.routeName); },
                    child: Icon(Icons.contact_page_rounded, color: kBlack, size: 14.w),
                  ))
            ]),
        SizedBox(height: 1.5.h,),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BigLabel(data: user.initialWeight.toStringAsPrecision(3), text: 'Peso Inicial'),
          BigLabel(data: user.height.toInt().toString(), text: 'Altura'),
          BigLabel(data: user.age.toString(), text: 'Edad'),
        ])
      ]);
  }
}
class BigLabel extends StatelessWidget {
  const BigLabel({required this.data, required this.text, Key? key}) : super(key: key);
  final String data;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextH1(data, color: kGreen, size: 7,),
      TextH2(text, color: kBlack, size: 3,)
    ]);
  }
}



/// JOURNAL WIDGET
class Journal extends StatelessWidget {
  const Journal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
        String type = ref.watch(journalCreator);
        if(type == 'Diario'){
          return Diary();
        }else if(type == 'Habitos'){
          return HabitList();
        }else if(type == 'Galeria'){
          return GalleryList();
        }else if(type == 'Medidas'){
          return MeasureList();
        }
        return JournalList();
    });
  }
}

/// ACTIVITY LIST WIDGET */
List<String>   _labelNames = ['Diario', 'Habitos', 'Galeria', 'Medidas'];
List<IconData> _labelIcons = [Icons.event_note_rounded, CustomIcons.habits, CustomIcons.camera_retro, CustomIcons.tape];
class JournalList extends StatelessWidget {
  const JournalList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: _labelNames.length+1,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            controller: ScrollController( keepScrollOffset: true ),
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              if(index==0){
                return  Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox( width: 20.w,
                            child: GestureDetector(
                              child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                              onTap: ()=> Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName)),
                            )),
                        SizedBox(width: 2.w,),
                        Icon(Icons.man_rounded, size: 5.w, color: kGreen,),
                        const TextH2("Revisa tu progreso", size: 4, color: kWhite,),
                        SizedBox(width: 20.w,)
                      ]),
                );
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: JournalLabel(
                      text: _labelNames[index-1],
                      icon: _labelIcons[index-1],
                  ));
            }));
  }
}
class JournalLabel extends StatelessWidget {
  const JournalLabel({required this.text, required this.icon, Key? key}) : super(key: key);
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () => context.ref.update(journalCreator, (p0) => text),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12.w, height: 12.w,
              decoration: BoxDecoration(
                  color: kBlue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w))
              ),
              child: Center(child: Icon(icon, color: kWhite, size: 7.w,),),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    color: kBlueSec,
                    borderRadius: BorderRadius.circular(3.w)
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextH2(text, color: kWhite, size: 4.2),
                )
            ),
          ],
        ));
  }
}



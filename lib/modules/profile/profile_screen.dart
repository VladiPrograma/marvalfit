import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/shadows.dart';
import 'package:marvalfit/modules/profile/widgets/journal_title_row.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/extensions.dart';
import '../../../firebase/users/model/user.dart';
import '../../../constants/colors.dart';
import '../../../constants/theme.dart';


import '../../../widgets/cached_avatar_image.dart';
import '../../../widgets/marval_drawer.dart';

import '../../utils/decoration.dart';
import 'journal/diary.dart';
import 'journal/gallery.dart';
import 'journal/habits.dart';
import 'journal/measures.dart';
import 'journal/see_form_screen.dart';
import 'logic/journal_creator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key}) : super(key: key);
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    String userId = uid!;
    return Scaffold(
        drawer: const MarvalDrawer(name: r'Perfil',),
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
             Positioned(  top: 0,
               child: SafeArea(
               child: SizedBox(width: 100.w,
               child: ProfileUserData(userId: userId,),
             ))),
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
             // Activities Widget
             Positioned( top: 28.h, child:  _Journal(userId: userId,) ),
       ])
      ),
    );
  }
}

/// PROFILE DATA
class ProfileUserData extends StatelessWidget {
  const ProfileUserData({ required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      User user = userLogic.get(ref) ?? User.empty();
      return Column(
          children: [
            SizedBox(height: 1.h,),
            // Profile Data
            Row( children: [
                  SizedBox(width: 7.w),
                  /// Profile image
                  Container(
                      decoration: BoxDecoration(
                        boxShadow: [kMarvalHardShadow],
                        borderRadius: BorderRadius.all(Radius.circular(100.w)),
                      ),
                      child: CachedAvatarImage(
                        url: user.profileImage.toString(),
                        expandable: true,
                        size: 5.5,
                      )),
                  SizedBox(width: 2.w),
                  /* User Data */
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h,),
                        TextH2('${user.name.removeIcon()} ${user.lastName}'.maxLength(18), size: 4),
                        TextH2(user.work, size: 3, color: kGrey,),
                        TextH2(('${user.hobbie}  ${user.favoriteFood}').maxLength(20), size: 3, color: kGrey,),
                      ]),
                  SizedBox(width: 4.w),
                  // Form Icon
                  Padding(padding: EdgeInsets.only(top: 4.5.h),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, SeeFormScreen.routeName),
                        child: Icon(Icons.contact_page_rounded, color: kBlack, size: 14.w),
                      ))
                ]),
            SizedBox(height: 1.5.h,),
            // Big Labels
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BigLabel(data: user.initialWeight.toStringAsPrecision(3) ?? '-', text: 'Peso Inicial'),
                  _BigLabel(data: user.height.toInt().toString() ?? '-', text: 'Altura'),
                  _BigLabel(data: user.age.toString() ?? '-', text: 'Edad'),
            ]),
          ]);
    });
  }
}
class _BigLabel extends StatelessWidget {
  const _BigLabel({required this.data, required this.text, Key? key}) : super(key: key);
  final String data;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      TextH1(data, color: kGreen, size: 7,),
      TextH2(text, color: kBlack, size: 3,)
    ]);
  }
}

/// JOURNAL WIDGET
class _Journal extends StatelessWidget {
  const _Journal({ required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
        JournalState state = watchJournal(ref);
        switch (state){
          case JournalState.LIST:
            return _JournalList(userId: userId);
          case JournalState.DIARY:
            return Diary(userId: userId);
          case JournalState.HABITS:
            return HabitList(userId: userId);
          case JournalState.GALLERY:
            return GalleryList(userId: userId);
          case JournalState.MEASURES:
            return MeasureList(userId: userId);
        }
    });
  }
}

/// ACTIVITY LIST WIDGET */

class _JournalList extends StatelessWidget {
  const _JournalList({required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: journalNames.length+1,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            controller: ScrollController( keepScrollOffset: true ),
            addRepaintBoundaries: false,
            itemBuilder: (context, index) {
              if(index==0){
                return  const JournalTitle(name: 'Datos del usuario', bottomMargin: 2,);
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: _JournalLabel(
                      text: journalNames[index-1],
                      icon: journalIcons[index-1],
                      state: JournalState.values[index-1],
                  ));
            }));
  }
}
class _JournalLabel extends StatelessWidget {
  const _JournalLabel({required this.text, required this.icon, required this.state, Key? key}) : super(key: key);
  final String text;
  final String icon;
  final JournalState state;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () => updateJournal(state, context.ref),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 12.w, height: 12.w,
              decoration: BoxDecoration(
                  color: kWhite,
                  boxShadow: [BoxShadow(
                    color: kBlackSec,
                    offset: Offset(0, 2.w),
                    blurRadius: 3.1.w,
                  )],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w),
                      bottomLeft: Radius.circular(3.w))
              ),
              child: Center(child: TextH1(icon, size: 4,),),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: kBlackSec,
                      offset: Offset(0, 2.w),
                      blurRadius: 3.1.w,
                    )],
                    color: kWhite,
                    borderRadius: BorderRadius.circular(3.w)
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextH2(text, color: kBlack, size: 4.2),
                )
            ),
          ],
        ));
  }
}



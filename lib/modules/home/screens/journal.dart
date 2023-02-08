import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/screens/note_measures.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/colors.dart';
import '../../../constants/theme.dart';
import '../../../constants/icons.dart';
import '../../../utils/marval_arq.dart';

import 'add_photos.dart';

HomeController _controller = HomeController();

bool rememberSave = false;
void _scrollDown(ScrollController scrollController){
  scrollController.animateTo(
      scrollController.positions.last.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutExpo
  );
}
void _scrollUp(ScrollController scrollController){
  scrollController.animateTo(
      scrollController.positions.last.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo
  );
}
/// JOURNAL WIDGET
class Journal extends StatelessWidget {
  const Journal({required this.scrollController, Key? key}) : super(key: key);
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      Daily daily = _controller.getDaily(ref);
      Activity activity = _controller.getActivity(ref);
      ActivityType type = activity.type;
      final trigger = _controller.hasChange(ref);
      switch (type) {
        case ActivityType.EMPTY:
          return MarvalActivityList(daily: daily, ref: ref);
        case ActivityType.CARDIO:
          //@TODO
          return MarvalActivityList(daily: daily, ref: ref);
        case ActivityType.MEASURES:
          return NoteMeasures(daily: daily, ref: ref, activity: activity,);
        case ActivityType.GALLERY:
          return AddPhotosToGallery(daily: daily, activity: activity, ref: ref,);
        default:
          return MarvalActivityList(daily: daily, ref: ref);
      }
    });
  }
}

/// ACTIVITY LIST WIDGET */

class MarvalActivityList extends StatelessWidget {
  const MarvalActivityList({required this.daily, required this.ref, Key? key}) : super(key: key);
  final Daily daily;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 34.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: ListView.builder(
            itemCount: isNull(daily) ? 1 : daily!.activities.length+1,
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
                        SizedBox(width: 2.w,),
                        Icon(Icons.bolt, size: 5.w, color: kGreen,),
                        const TextH2(" Completa tus tareas", size: 4, color: kWhite,),
                      ]),
                );
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: MarvalActivity(daily: daily, activity: daily.activities[index-1], ref: ref));
            }));
  }
}
class MarvalActivity extends StatelessWidget {
  const MarvalActivity({required this.activity, required this.daily, required this.ref, Key? key}) : super(key: key);
  final Activity activity;
  final Daily daily;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
            if(activity.type == ActivityType.REST){
              activity.completed = !activity.completed;
              _controller.updateActivity(ref, daily, activity);
            }
            else{
              _controller.setActivity(ref, activity);
            }
        },
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
              child: Center(child: Icon(mapIcons[activity.type], color: kWhite, size: 5.w,)),
            ),
            SizedBox(width: 6.w,),
            Container(width: 50.w, height: 12.w,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                  color: kBlueSec,
                  borderRadius: BorderRadius.circular(3.w)
              ),
              child: Row(
                  children: [
                    TextH2(activity.label.maxLength(16) , color: kWhite, size: 3.6,),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.w),
                            border: Border.all(
                                width: 0.4.w,
                                color: kWhite
                            )
                        ),
                        child: CircleAvatar(
                            backgroundColor: activity.completed ? kBlue : kBlack,
                            radius: 1.8.w,
                         ))
                  ]),
            ),
          ],
        ));
  }
}

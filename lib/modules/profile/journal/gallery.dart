import 'package:marvalfit/modules/profile/widgets/journal_title_row.dart';
import 'package:marvalfit/widgets/load_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:marvalfit/utils/extensions.dart';
import 'package:marvalfit/widgets/show_fullscreen_image.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';

import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/global_variables.dart';
import 'package:marvalfit/constants/theme.dart';



import 'package:marvalfit/utils/marval_arq.dart';

ScrollController _returnController(Ref ref, int size){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ galleryLogic.fetchMore(ref, size); }});
  return res;
}

class GalleryList extends StatelessWidget {
  const GalleryList({required this.userId, Key? key}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w, height: 72.h,
        child: Watcher((context, ref, child) {
          List<Gallery> images = galleryLogic.get(ref, userId);
          bool hasMoreData= galleryLogic.hasMore(ref);
          return ListView.builder(
              controller: _returnController(ref, images.length),
              itemCount: hasMoreData ? images.length+2 : images.length + 1,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                /// Title
                if(index==0){ return const JournalTitle(name: "Fotos del usuario"); }
                if(index == images.length+1 && hasMoreData){ return const  LoadIndicator(); }
                return GalleryLabel(gallery: images[index-1]);
              });
        }));
  }
}
class GalleryLabel extends StatelessWidget {
  const GalleryLabel({required this.gallery, Key? key}) : super(key: key);
  final Gallery gallery;
  @override
  Widget build(BuildContext context) {
    String aestheticDate = '${gallery.date.day} ${gallery.date.toStringMonth().toLowerCase()} ${gallery.date.year}';
    return  Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 1.3.h),
        padding: EdgeInsets.symmetric( vertical: 2.h),
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(
                offset: Offset(0, 3.w),
                color: kBlackSec,
                blurRadius: 4.w
            )],
            color: kBlack,
            borderRadius: BorderRadius.circular(8.w)
        ),
        child:   Column( children: [
          // Date Title
          Row(children: [
            SizedBox(width: 6.w),
            TextH2(gallery.date.toStringWeekDayLong(), color: kWhite, size: 3.8),
            const Spacer(),
            TextH2(aestheticDate, color: kWhite, size: 3.8),
            SizedBox(width: 6.w),
          ]),
          SizedBox(height: 2.h,),
          ImageFrame(text: 'Frontal',  url: gallery.frontal),
          ImageFrame(text: 'Perfil',   url: gallery.perfil),
          ImageFrame(text: 'Espalda',  url: gallery.espalda),
          ImageFrame(text: 'Piernas',  url: gallery.piernas)
        ]));
  }
}
class ImageFrame extends StatelessWidget {
  const ImageFrame({required this.text, required this.url, Key? key}) : super(key: key);
  final String text;
  final String? url;
  @override
  Widget build(BuildContext context) {
    return  isNullOrEmpty(url) ? const SizedBox.shrink()
        :  Column(children: [
      Container(width: 47.w, height: 47.w,
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                  offset: Offset(0, 2.w),
                  color: kBlackSec,
                  blurRadius: 3.w
              )],
              borderRadius: BorderRadius.circular(5.w)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.w),
            child: CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => FullScreenImage(url: url!, image: imageProvider),
                placeholder: (context, url) =>  Container(color: kBlack, child: Icon(Icons.image, size: 25.w, color: kWhite)),
            ),
      )),
      SizedBox(height: 3.h)
    ]);
  }
}

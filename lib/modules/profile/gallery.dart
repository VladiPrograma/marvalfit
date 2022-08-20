import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:marvalfit/config/custom_icons.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/extensions.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/gallery.dart';
import 'logic.dart';

ScrollController _returnController(Ref ref){
  ScrollController  res = ScrollController();
  res.addListener((){ if(res.position.maxScrollExtent==res.offset){ _fetchMorePhotos(ref); }});
  return res;
}

final _galleryEmitter = Emitter.stream((ref) async {
  return  FirebaseFirestore.instance.collection('users/${authUser.uid}/activities')
      .where('type', isEqualTo: idGallery)  
      .orderBy('date', descending: true).limit(ref.watch(_page)).snapshots();
});

final _page = Creator.value(3);
void  _fetchMorePhotos(Ref ref,{int? add}) => ref.update<int>(_page, (n) => n + (add ?? 3));


List<Gallery>? _getLoadGalleries(Ref ref){
  final query = ref.watch(_galleryEmitter.asyncData).data;
  if(isNull(query)||query!.size==0){ return null; }
  //Pass data from querySnapshot to Messages
  final List<Gallery> list = _queryToData(query);

  return list;
}

///* Internal Logic ///
List<Gallery> _queryToData(QuerySnapshot<Map<String, dynamic>> query){
  List<Gallery> list = [];
  for (var element in [...query.docs]){
    list.add(Gallery.fromJson(element.data()));
  }
  return list;
}

class ImageFrame extends StatelessWidget {
  const ImageFrame({required this.text, required this.url, Key? key}) : super(key: key);
  final String text;
  final String? url;
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5.w),
              child: Container(width: 35.w, height: 35.w, color: kBlue,
                  child:
                  isNull(url) ?
                  Center(child: Icon(Icons.image, size: 25.w, color: kWhite, shadows: [kMarvalBoxShadow],))
                      :
                  Image.network(url!, fit: BoxFit.cover,)
              )),
          Container( width: 35.w,
              padding: EdgeInsets.all(1.w),
              margin: EdgeInsets.only(top: 2.w),
              decoration: BoxDecoration(
                color: kBlueSec,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: TextH1(text, color: kWhite, size: 4.5, textAlign: TextAlign.center,)),
        ]);
  }
}
class GalleryLabel extends StatelessWidget {
  const GalleryLabel({required this.gallery, Key? key}) : super(key: key);
  final Gallery? gallery;
  @override
  Widget build(BuildContext context) {
    return  Container( width: 100.w, height: 61.5.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:   Column(
            children: [
              Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width:20.w, height: 0.2.w, color: kWhite,),
                    TextH1(' ${gallery?.date.id} ', color: kWhite, size: 5,),
                    Container(width:20.w, height: 0.2.w, color: kWhite,),
                  ]),
              SizedBox(height: 2.h),
              Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ImageFrame(text: 'Frontal',  url: gallery?.frontal),
                          ImageFrame(text: 'Perfil',   url: gallery?.perfil)
                        ]),
                    SizedBox(height: 3.h,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ImageFrame(text: 'Espalda',  url: gallery?.espalda),
                          ImageFrame(text: 'Piernas',  url: gallery?.piernas)
                        ]),
                  ]),
              SizedBox(height: 3.h),
            ]));
  }
}
class GalleryList extends StatelessWidget {
  const GalleryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w, height: 76.h,
        child: Watcher((context, ref, child) {
          List<Gallery>? galleries = _getLoadGalleries(ref);
          logInfo(galleries ?? ' ta vacio');
          if(isNull(galleries)){ return Container(width: 100.w,
            margin: EdgeInsets.only(top: 2.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox( width: 20.w,
                      child: GestureDetector(
                        child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                        onTap: ()=> context.ref.update(journalCreator, (p0) => 'List'),
                      )),
                  const TextH2("Tu progreso en fotos", size: 4, color: kWhite,),
                  ///@TODO On fetching more data set here loading button to indicate we are loading more data
                  SizedBox( width: 20.w)
                ]),);}
          return ListView.builder(
              controller: _returnController(ref),
              itemCount: galleries!.length+1,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                /// Title
                if(index==0){
                  return SizedBox(width: 100.w,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox( width: 20.w,
                              child: GestureDetector(
                                child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                                onTap: ()=> context.ref.update(journalCreator, (p0) => 'List'),
                              )),
                          const TextH2("Tu progreso en fotos", size: 4, color: kWhite,),
                          ///@TODO On fetching more data set here loading button to indicate we are loading more data
                          SizedBox( width: 20.w)
                        ]),);
                }
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: GalleryLabel(gallery: galleries[index-1],));
              });
        }));
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/firebase/dailys/model/activity.dart';
import 'package:marvalfit/firebase/dailys/model/daily.dart';
import 'package:marvalfit/firebase/gallery/model/gallery.dart';
import 'package:marvalfit/modules/home/controllers/home_controller.dart';
import 'package:marvalfit/modules/home/widgets/journal_title.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';


import '../../../constants/colors.dart';
import '../../../constants/shadows.dart';
import '../../../constants/theme.dart';
import '../../../utils/marval_arq.dart';

import 'journal.dart';

///@TODO Add load icon when loading data.
///@TODO Make the save button availaible one time once to avoid multiple upload of the same images.
///

HomeController _controller = HomeController();

class AddPhotosToGallery extends StatelessWidget {
  const AddPhotosToGallery({required this.daily,required this.activity,  required this.ref,  Key? key}) : super(key: key);
  final Daily daily;
  final Activity activity;
  final Ref ref;
  @override
  Widget build(BuildContext context) {
    _initImageList();
    return  SizedBox( width: 100.w, height: 34.h,
        child:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
                children: [
                  const JournalTitle(name: r'Amplia la galeria',topMargin: 2),
                  SizedBox(height: 2.h),
                  Watcher((context, ref, child){
                    Gallery? gallery = _controller.getGallery(ref);
                    if(activity.reference.isNotEmpty){
                      _controller.initGallery(ref, activity.reference, gallery);
                    }
                    gallery ??= Gallery.create(date: DateTime.now());
                    return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageFrame(text: 'Frontal',  url: gallery.frontal),
                                ImageFrame(text: 'Perfil',  url: gallery.perfil)
                              ]),
                          SizedBox(height: 3.h,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageFrame(text: 'Espalda',  url: gallery.espalda),
                                ImageFrame(text: 'Piernas',url: gallery.piernas)
                              ]),
                        ]);
                  }),
                  SizedBox(height: 3.h),
                  ElevatedButton(
                      onPressed: () async{
                        _controller.addGalleryActivity(context.ref, daily, activity, _imageList);
                        _controller.initActivity(ref);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all( RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w))),
                        backgroundColor: MaterialStateColor.resolveWith((states) => kGreen),
                      ),
                      child: Container(
                          padding: EdgeInsets.all(1.71.w),
                          child:  TextH1( "Guardar", color: kWhite, size: 5,))
                  ),
                  SizedBox(height: 3.h),
                ])
        ));
  }
}

Map<String, XFile?> _imageList = {};
void _initImageList(){
  _imageList = {
    'Frontal' : null,
    'Perfil' : null,
    'Espalda' : null,
    'Piernas' : null,
  };
}

final ImagePicker _picker = ImagePicker();
class ImageFrame extends StatefulWidget {
  const ImageFrame({required this.text,  this.url, Key? key}) : super(key: key);
  final String text;
  final String? url;
  @override
  State<ImageFrame> createState() => _ImageFrameState();
}
class _ImageFrameState extends State<ImageFrame> {

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          GestureDetector(
              onTap: () async{
                XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                if(isNotNull(file)){
                  _imageList[widget.text] = file;
                  rememberSave = true;
                }
                setState(() { });
              },
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(5.w),
                  child: Container(width: 35.w, height: 35.w, color: kBlue,
                    child:
                    isNull(_imageList[widget.text]) ?
                    isNullOrEmpty(widget.url)?
                    Center(child: Icon(Icons.image, size: 25.w, color: kWhite, shadows: [kMarvalBoxShadow],))
                        :
                    Image.network(widget.url!, fit: BoxFit.cover,)
                        :
                    Image.file(File(_imageList[widget.text]!.path), fit: BoxFit.cover),
                  ))

          ),
          Container( width: 35.w,
              padding: EdgeInsets.all(1.w),
              margin: EdgeInsets.only(top: 2.w),
              decoration: BoxDecoration(
                color: kBlueSec,
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: TextH1(widget.text, color: kWhite, size: 4.5, textAlign: TextAlign.center,)),
        ]);
  }
}
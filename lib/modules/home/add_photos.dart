import 'dart:io';

import 'package:flutter/material.dart';
import 'package:creator/creator.dart';
import 'package:sizer/sizer.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/custom_icons.dart';
import '../../config/log_msg.dart';

import '../../constants/colors.dart';
import '../../constants/shadows.dart';
import '../../constants/theme.dart';
import '../../constants/global_variables.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';

import '../../utils/objects/gallery.dart';
import '../../utils/firebase/storage.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';

import '../../widgets/marval_snackbar.dart';
import '../../widgets/marval_dialogs.dart';
import '../../widgets/marval_textfield.dart';

import 'journal.dart';
import 'logic.dart';
import 'note_measures.dart';

///@TODO Add load icon when loading data.
///@TODO Make the save button availaible one time once to avoid multiple upload of the same images.
class AddPhotosToGallery extends StatelessWidget {
  const AddPhotosToGallery({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    return  Container( width: 100.w, height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:  SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox( width: 20.w,
                            child: GestureDetector(
                              child: Icon(CustomIcons.arrow_left, size: 7.w, color: kGreen),
                              onTap: (){
                                if(rememberSave){
                                  MarvalDialogsAlert(context, type: MarvalDialogAlertType.DELETE, height: 28,
                                      title: '¿ Salir sin guardar? ',
                                      richText: RichText(text: TextSpan(text: 'Si sales sin guardar tus datos se perderan para siempre',
                                        style: TextStyle(fontFamily: p2, fontSize: 4.w, color: kBlack),)),
                                      acceptText: 'Salir',
                                      onAccept: (){
                                        context.ref.update(activityCreator, (t) => 'List');
                                        rememberSave=false;}
                                  );}
                                else{
                                  context.ref.update(activityCreator, (t) => 'List');
                                  _backgroundImageList = List.generate(4, (index) => {}); }},
                            )),
                        const TextH2("Amplia tu Galeria", size: 4, color: kWhite,),
                        SizedBox( width: 20.w,
                            child: GestureDetector(
                              onTap: (){ /**@TODO implement video or image or something*/ },
                              child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                            )),
                      ]),
                  SizedBox(height: 2.h),
                  Watcher((context, ref, child){
                    Gallery? gallery = ref.watch(galleryEmitter.asyncData).data;

                    return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageFrame(text: 'Frontal', index: 0, url: gallery?.frontal),
                                ImageFrame(text: 'Perfil', index: 1, url: gallery?.perfil)
                              ]),
                          SizedBox(height: 3.h,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ImageFrame(text: 'Espalda', index: 2, url: gallery?.espalda),
                                ImageFrame(text: 'Piernas',index: 3, url: gallery?.piernas)
                              ]),
                        ]);
                  }),
                  SizedBox(height: 3.h),
                  ElevatedButton(
                      onPressed: () async{
                        if(rememberSave=true && isNotNull(daily)){
                          rememberSave = false;
                          bool exists = true;
                          /// * FIREBASE DAILY UPDATE
                          String reference = daily!.id+idGallery;
                          Map<String, dynamic> activity = daily!.activities.where((element) => element['label']=='Galeria').first;
                          if(isNull(activity['completed']) || !activity['completed']){
                            exists = false;
                            activity['completed']= true;
                            activity['reference']= reference;
                            daily!.updateActivity(activity);
                          }

                          /// * FIREBASE ACTIVITY UPDATE
                          Map<String, String> mapGallery = {};
                          for (var map in _backgroundImageList){
                            if(isNotNull(map)&&map.isNotEmpty){
                              String url = await uploadImageFromGallery(user.id, map.keys.first, daily!.date, map.values.first!);
                              mapGallery[map.keys.first.toLowerCase()] = url;
                            }
                          }

                          if(mapGallery.isNotEmpty){
                            if(exists){
                              Gallery? gallery = context.ref.watch(galleryEmitter.asyncData).data;
                              if(isNotNull(gallery)){
                                gallery!.upload(mapGallery)
                                    .whenComplete(() => MarvalSnackBar(null,  SNACKTYPE.success,
                                    title: 'Bien hecho !',
                                    subtitle: 'Las fotos se han subido con exito Si pudiera contar la historia en palabras, no necesitaría llevar una cámara encima.')
                                );
                              }
                            }else{
                              Gallery gallery = Gallery.fromMap(date: daily!.date, map: mapGallery);
                              gallery.setInDB()
                                  .whenComplete(() => MarvalSnackBar(null,  SNACKTYPE.success,
                                  title: 'Bien hecho !',
                                  subtitle: 'Las fotos se han subido con exito Si pudiera contar la historia en palabras, no necesitaría llevar una cámara encima.')
                              );
                            }
                          }
                        }
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
Emitter<Gallery?> galleryEmitter = Emitter((ref, emit) async{
  Daily? daily = getDaily(ref);
  if(isNull(daily)) {emit(null);}
  String? reference = daily!.activities.where((element) => element['label']== 'Galeria').first['reference'];
  if(isNull(reference)) emit(null);
  if(isNotNull(reference)) {
    try{
      Gallery? gallery = await Gallery.getFromBD(daily.date);
      emit(gallery);
    }catch(e){
      emit(null);
    }

  }
});
List<Map<String, XFile?>> _backgroundImageList = List.generate(4, (index) => {});
final ImagePicker _picker = ImagePicker();
class ImageFrame extends StatefulWidget {
  const ImageFrame({required this.text, required this.index, this.url, Key? key}) : super(key: key);
  final String text;
  final int index;
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
                  _backgroundImageList[widget.index] = {widget.text : file};
                  rememberSave = true;
                }
                setState(() { });
              },
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(5.w),
                  child: Container(width: 35.w, height: 35.w, color: kBlue,
                    child:
                    isNull(_backgroundImageList[widget.index][widget.text]) ?
                    isNull(widget.url) ?
                    Center(child: Icon(Icons.image, size: 25.w, color: kWhite, shadows: [kMarvalBoxShadow],))
                        :
                    Image.network(widget.url!, fit: BoxFit.cover,)
                        :
                    Image.file(File(_backgroundImageList[widget.index][widget.text]!.path), fit: BoxFit.cover),
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
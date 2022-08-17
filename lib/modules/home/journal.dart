import 'dart:io';

import 'package:creator/creator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marvalfit/config/log_msg.dart';
import 'package:marvalfit/constants/colors.dart';
import 'package:marvalfit/constants/components.dart';
import 'package:marvalfit/constants/theme.dart';
import 'package:marvalfit/utils/objects/gallery.dart';
import 'package:marvalfit/utils/objects/measures.dart';
import 'package:marvalfit/widgets/marval_dialogs.dart';
import 'package:marvalfit/widgets/marval_elevated_button.dart';
import 'package:sizer/sizer.dart';

import '../../config/custom_icons.dart';
import '../../constants/global_variables.dart';
import '../../constants/icons.dart';
import '../../constants/string.dart';
import '../../utils/firebase/storage.dart';
import '../../utils/marval_arq.dart';
import '../../utils/objects/user_daily.dart';
import '../../widgets/marval_snackbar.dart';
import '../../widgets/marval_textfield.dart';
import 'logic.dart';


void _scrollDown(ScrollController controller){
  controller.animateTo(
      controller.positions.last.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutExpo
  );
}
void _scrollUp(ScrollController controller){
  controller.animateTo(
      controller.positions.last.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo
  );
}
/// JOURNAL WIDGET
class Journal extends StatelessWidget {
  const Journal({required this.controller, Key? key}) : super(key: key);
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child){
      Daily? daily = getDaily(ref);
      if(isNull(daily)) return const SizedBox();
      String type = ref.watch(activityCreator);
      if(type == 'List'){
       _scrollDown(controller);
       ref.update(activityCreator, (p0) => 'Init');
      }

      if(type == 'Medidas') {
        _scrollUp(controller);
        return Medidas(daily: daily);

      } else if(type == 'Galeria'){
        _scrollUp(controller);
        return Galeria(daily: daily);

      } else{ return MarvalActivityList(daily: daily);}
    });
  }
}

/// ACTIVITY LIST WIDGET */
class MarvalActivity extends StatelessWidget {
  const MarvalActivity({required this.activity, required this.daily, Key? key}) : super(key: key);
  final Map<String, dynamic>? activity;
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: () {
          String type = activity!['label'];
          if(isNotNull(daily)&&isNotNull(activity)){
            if(type == 'Descanso'){
              activity!['completed']= isNull(activity?['completed']) ? true : !activity!['completed'] ;
              daily!.updateActivity(activity!);
              /// Guardar en activities
            }
            else if(type == 'Pasos'){
              RichText _richText = RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: "Está demostrado que caminar quema más grasa y calorías que otros ejercicios, ayuda a que el sistema cardiovascular se active y fortifique, y te ayuda a eliminar el colesterol perjudicial para el organismo.",
                  style: TextStyle(fontFamily: p2, fontSize: 4.5.w, color: kBlack),
                ),
              );
              int _steps = 0;
              GlobalKey<FormState> _formKey = GlobalKey();
              Form _form = Form(
                key: _formKey,
                child: MarvalInputTextField(
                  labelText: 'Pasos',
                  hintText: "",
                  prefixIcon: CustomIcons.leg,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(isNullOrEmpty(value)) return kEmptyValue;
                    try{
                      int.parse(value!);
                    }catch(e){
                      return 'Debes introducir un numero entero';
                    }
                    return null;
                  },
                  onSaved: (value){ _steps= int.parse(value!);},
                ),
              );
              MarvalDialogsInput(context,
                  title: '¡ Apunta tus pasos !',
                  height: 50,
                  form: _form,
                  richText: _richText,
                  onSucess: (){
                    activity!['completed']= isNull(activity?['completed']) ? true : !activity!['completed'] ;
                    daily!.updateActivity(activity!);
                  }
              );
            }
            else if(type == 'Medidas'|| type == 'Galeria'){
              context.ref.update(activityCreator, (s) => activity!['label']);}
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
              child: Center(child: Icon(mapIcons[activity?['icon']] ?? mapIcons[''], color: kWhite, size: 7.w,),),
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
                    TextH2(activity?['label'] ?? '', color: kWhite, size: 4.2,),
                    const Spacer(),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.w),
                            border: Border.all(
                                width: 0.4.w,
                                color: kWhite
                            )
                        ),
                        child:Watcher((context, ref, child) {
                          return CircleAvatar(
                            backgroundColor: isNull(activity?['completed'])  ? kBlack
                                : activity!['completed'] ? kBlue : kBlack,
                            radius: 1.8.w,
                          );
                        }))
                  ]),
            ),
          ],
        ));
  }
}
class MarvalActivityList extends StatelessWidget {
  const MarvalActivityList({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
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
                        Icon(Icons.man_rounded, size: 5.w, color: kGreen,),
                        const TextH2(" Completa tus tareas", size: 4, color: kWhite,),
                      ]),
                );
              }
              return Container(
                  margin: EdgeInsets.only(bottom: 1.5.h),
                  child: MarvalActivity(daily: daily, activity: daily?.activities[index-1] ?? {},));
            }));
  }
}

/// MEDIDAS WIDGET
/// 
Emitter<List<DataRow>> dataRowEmitter = Emitter((ref, emit){
  Measures measure = Measures.create(date: ref.watch(dateCreator));
  emit(DataRowList(measure));
});

final _formKey = GlobalKey<FormState>();

Map<String, double>? _bodyParts;
bool _rememberSave = false;
Emitter<Measures?> measureEmitter = Emitter((ref, emit) async{
  Daily? daily = getDaily(ref);
  if(isNull(daily)) {emit(null);}
  String? reference = daily!.activities.where((element) => element['label']== 'Medidas').first['reference'];
  if(isNull(reference)) {emit(Measures.create(date: ref.watch(dateCreator)));}
  if(isNotNull(reference)) {emit(await Measures.getFromBD(daily.date));}
});

class Medidas extends StatelessWidget {
  const Medidas({required this.daily, Key? key}) : super(key: key);
  final Daily? daily;
  @override
  Widget build(BuildContext context) {
    return Container( width: 100.w, height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child:  SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Form( key: _formKey,
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
                       if(_rememberSave){
                         MarvalDialogsAlert(context, type: MarvalDialogAlertType.DELETE, height: 28,
                             title: '¿ Salir sin guardar? ',
                             richText: RichText(text: TextSpan(text: 'Si sales sin guardar tus datos se perderan para siempre',
                               style: TextStyle(fontFamily: p2, fontSize: 4.w, color: kBlack),)),
                             acceptText: 'Salir',
                             onAccept: (){
                               context.ref.update(activityCreator, (t) => 'List');
                               _rememberSave=false;}
                         );}
                       else{
                         context.ref.update(activityCreator, (t) => 'List');
                       }},
                     )),
                    const TextH2("Apunta tus medidas", size: 4, color: kWhite,),
                    SizedBox( width: 20.w,
                    child: GestureDetector(
                     onTap: (){ /**@TODO implement video or image or something*/ },
                     child: Icon(CustomIcons.info, size: 5.w, color: kGreen),
                    )),
                  ]),
                  Watcher((context, ref, child){
                    Measures? measure = ref.watch(measureEmitter.asyncData).data;
                    if(isNull(measure)) return const SizedBox();
                    return DataTable(
                      border: const TableBorder(horizontalInside: BorderSide(color: kWhite)),
                      columns:  [
                        DataColumn(label: SizedBox(width: 40.w,
                            child: const TextH2('Zona',
                              size: 4,
                              color: kWhite,
                              textAlign: TextAlign.start
                        ))),
                        DataColumn(label: SizedBox(width: 30.w,
                            child: const TextH2('Medida (cm)',
                                size: 4,
                                color: kWhite,
                                textAlign: TextAlign.center
                        ))),
                      ],
                      rows: DataRowList(measure ?? Measures.create(date: ref.watch(dateCreator))),
                      );
                    }),
                    SizedBox(height: 5.h,),
                    MarvalElevatedButton('Guardar',
                        backgroundColor: MaterialStateColor.resolveWith((states) => kGreen.withOpacity(0.9)),
                        onPressed: (){
                          if (_formKey.currentState!.validate()&&isNotNull(daily)&&_rememberSave) {
                            _formKey.currentState!.save();
                            _rememberSave = false;
                            /// FIREBASE DAILY UPDATE
                            String reference = daily!.id+idMeasures;
                            Map<String, dynamic> activity = daily!.activities.where((element) => element['label']=='Medidas').first;
                            activity['completed']= true;
                            activity['reference']= reference;
                            daily!.updateActivity(activity);
                            /// FIREBASE MEASURE UPDATE
                            Measures measure = Measures.fromMap(date: daily!.date, map: _bodyParts! );
                            measure.setInDB().whenComplete((){
                              MarvalSnackBar(context, SNACKTYPE.success,
                               title: 'Nuevas medidas apuntadas!',
                               subtitle: 'Aquellos que quieren cantar siempre encuentran una canción');
                            });
                          }
                        }),
                    Container(height: 25.h,
                       padding: EdgeInsets.only(top: 10.h),
                       ///@TODO Cambiar por un negativo del logo de Mario
                       child: TextH1('MarvalFit', color: kGreenThi, size: 8,)
                      ),
                  ])
          ),
        )
    );
  }
}

///@TODO Change this with some nice Methods...
DataRow MarvalDataRow(String text, double num){
  return DataRow(cells: [
    DataCell(SizedBox(width: 40.w, child:TextH2(text, size: 4, color: kWhite, textAlign: TextAlign.start))),
    DataCell(SizedBox(width: 30.w, child:
    TextFormField(
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      scrollPadding: EdgeInsets.only(bottom: 37.h),
      cursorColor: kGreen,
      style: TextStyle(fontFamily: h2, fontSize: 4.w, color: kWhite),
      decoration:  InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(fontFamily: h2, fontSize: 4.w, color: kWhite),
          hintText: num==0 ? '0' : num.toStringAsPrecision(3),
      ),
      onTap: ()=> _rememberSave = true,
      onSaved: (newValue) {
        if(isNotNull(newValue)&&isNotEmpty(newValue)){
         try{
           _bodyParts?[text] = double.parse(newValue!);
         }catch(e){
           logError(e);
         }}
      }))
 )]);
}
List<DataRow> DataRowList(Measures measures){
  _bodyParts = measures.bodyParts();
  List<DataRow> list = [];
  _bodyParts!.forEach((key, value) {
    list.add(MarvalDataRow(key, value));
  });
  return list;
}

/// GALLERY ICONS

class Galeria extends StatelessWidget {
  const Galeria({required this.daily, Key? key}) : super(key: key);
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
                  if(_rememberSave){
                      MarvalDialogsAlert(context, type: MarvalDialogAlertType.DELETE, height: 28,
                    title: '¿ Salir sin guardar? ',
                    richText: RichText(text: TextSpan(text: 'Si sales sin guardar tus datos se perderan para siempre',
                      style: TextStyle(fontFamily: p2, fontSize: 4.w, color: kBlack),)),
                    acceptText: 'Salir',
                    onAccept: (){
                    context.ref.update(activityCreator, (t) => 'List');
                    _rememberSave=false;}
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
                    if(_rememberSave=true && isNotNull(daily)){
                    _rememberSave = false;
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
                  _rememberSave = true;
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

